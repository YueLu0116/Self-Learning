# latex用法之参考文献引用

> 文档说明：每次（其实也就两次）用latex写论文，都对Latex中利用BibTex引用参考文献的方式不是很熟悉，这里简单总结。
>
> 日期：2019年12月25日

1. 对.tex文件进行编译，生成.aux文件；
2. 写好.bib文件，假设文件名为`reference.bib`；
3. 要插入参考文献的地方插入语句：`\bibliography{reference}`
4. 定义_风格_，在`\begin{document}`后加上`\bibliographystyle{xxx}`，其中xxx为相关风格，不同期刊参考文献的风格不同，iet模板给出了.bst文件，即参考文献的风格定义文件，直接把xxx换为iet即可。
5. 最后再编译，即可加入参考文献。
6. 理论上，参考的文献原文中必须引用（`\cite{ref}`），但如果有没有引用的，应该在`\begin{document}` 后加上`\nocite{*}`。