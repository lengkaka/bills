<?php
/**
 * Helper_StaticCompile
 * js
 *
 *     作者: simon (simon@huoban.com)
 * 创建时间: 2013-12-11 17:20:53
 * 修改记录:
 *
 * $Id: staticCompile.php 296 2013-12-12 07:13:11Z wangjia $
 */
class Helper_StaticCompile {

    /**
     * _startsWith 
     * 判断是否以$needle开头
     */
    private static function _startsWith($haystack, $needle) {
        return $needle === "" || strpos($haystack, $needle) === 0;
    }
    
    /**
     * _endsWith 
     * 判断是否以$needle结尾
     */
    private static function _endsWith($haystack, $needle) {
        return $needle === "" || substr($haystack, -strlen($needle)) === $needle;
    }

    /**
     * getTpls 
     * 获取所有tpl文件
     */
    private static function _getTpls($dir) {

        $tplFiles = array();
        if (is_dir($dir)) {
            $dh = openDir($dir);
            while(($file = readdir($dh)) !== false) {
                $filePath = $dir . '/' . $file;
                $fileType = filetype($filePath);
                if ($fileType == 'dir' && $file != '.' && $file != '..') {
                    $subDirTpls = self::_getTpls($filePath);
                    $tplFiles = array_merge($tplFiles, $subDirTpls);
                } else if ($fileType == 'file') {
                    if (self::_endsWith($filePath, '.tpl')) {
                        array_push($tplFiles, $filePath);
                    }
                }
            }
            closedir($dh);
        }
        return $tplFiles;
    }
    
    /**
     * compile_jsTemplate
     * 编译所有的tpl
     */
    public static function compile_jsTemplate() {

        $tpl_dir = '../templates';
        $tpls = self::_getTpls($tpl_dir);
        if (is_array($tpls)) {
            foreach($tpls as $tpl) {
                $source_file_path = $tpl;
                $compile_file_path = $tpl . '.js';
                self::compile_Template($source_file_path, $compile_file_path);
            }
        }
    }

    /**
     * _compile_jsTemplate
     * 编译artTemplate模版文件内容为seajs的一个模块
     *
     * @param  string $tpl_id 模版ID（确定此模版的唯一标识，一般为此模版的绝对URL地址）
     * @param  string $tpl 原始模版文件数据
     */
    public static function compile_Template($source_file_path, $compile_file_path) {

        if (!$source_file_path|| !$compile_file_path) {
            return '';
        }

        $tpl_id = md5($source_file_path);
        $source_file_content = file_get_contents($source_file_path);

        try {

            $tpl = $source_file_content;
            // 去除换行和空格，转义"和'
            $tpl = addslashes(implode('', array_map('trim', explode("\n", $tpl))));

            $tpl_compiled = "define(['view_helper'], function(ViewHelper) {\n";
            $tpl_compiled .= "    return ViewHelper.compile('$tpl');\n";
            $tpl_compiled .= '});';

        } catch (Exception $e) {

            // 写错PHP类名或常量名时，通过JS抛异常方式通知开发、测试人员
            $tpl_compiled = "define(function() {";
            $tpl_compiled .= "    throw new Error('" . $e->getMessage() . "');";
            $tpl_compiled .= '});';

        }

        file_put_contents($compile_file_path, $tpl_compiled);

        return true;
    }
};

if (count($argv) > 1) {
    $tpl = $argv[1];
    $source_file_path = $tpl;
    $compile_file_path = $tpl . '.js';
    Helper_StaticCompile::compile_Template($source_file_path, $compile_file_path);
} else {
    Helper_StaticCompile::compile_jsTemplate();
}
