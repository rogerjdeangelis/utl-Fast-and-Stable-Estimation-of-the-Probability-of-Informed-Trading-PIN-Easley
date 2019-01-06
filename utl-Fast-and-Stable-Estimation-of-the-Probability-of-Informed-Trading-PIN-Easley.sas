Fast and Stable Estimation of the Probability of Informed Trading

github
https://tinyurl.com/ybehh7jc
https://github.com/rogerjdeangelis/utl-Fast-and-Stable-Estimation-of-the-Probability-of-Informed-Trading-PIN-Easley

https://tinyurl.com/y77urrjc
https://communities.sas.com/t5/New-SAS-User/PIN-in-Easley-et-al-1996-and-PIN-in-Easley-et-al-2002/m-p/524762

For documentation
https://cran.r-project.org/web/packages/pinbasic/readme/README.html

SOAPBOX ON

  LESS IS MORE

  It is very difficult to interface Python and R with other languages.
  It was difficult to import and export data to/from R because of
       1. Rownames
       2. Factors
       3. named vectors
       4. column names
       5. Very complex lists with combiantions of the above
       6. Arrays, matricies, vector,numbers,characters,tibls, data.Table, dataframes, lists...
       7. Logicals, Integers, factors, atomic, character, numeric, complex

  R and Python packages should avoid very complex list data structures.
  Lists on one or two datatypes ate the most.

  Although it took only one line of code for the estimation, it took a dozen
  verycomplicated lines of code to get the data into a dataframe that SAS could
  operate on.

SOAPBOX OFF

The dataset BSfrequent cover 60 trading days and represent a frequently traded equity.
Model parameters and the probability of informed trading can be estimated with pin_est.

BSfrequent2015 contains simulated daily buys and sells for a frequently traded
equity for business days in 2015. qpin returns quarterly estimates which
can be visualized with ggplot.

# Quarterly PIN estimates
# Confidence interval computation enabled:
#   * using only 1000 simulated datasets
#   * confidence level set to 0.95
#   * seed set to 123


*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

INPUT
=====

options validvarname=upcase;
libname sd1 "d:/sd1";

data sd1.BSfrequent;
  input buys sells @@;
cards4;
2279 2009 2166 2065 2180 2002 2248 2937 3062 2041 2194 2055 2183 1955 2203 2757
2210 2000 2215 1967 2983 2010 2174 1992 2308 1947 2198 1955 2231 2000 2241 2821
2191 2038 2162 1971 2315 1992 3052 2051 2278 2752 2192 2003 2220 1955 2955 2010
2243 2003 2194 1964 2180 2064 2164 2029 2172 1956 2219 1945 3041 1974 2935 1981
2147 2046 2221 2022 2128 2023 2229 1992 2257 1990 2192 2002 2188 1984 2276 2102
2192 2028 2160 2031 2203 2000 2211 1966 2211 1896 2237 2050 2216 2036 2212 1947
2244 2042 2189 2962 2253 2000 2153 1970 2135 1984 2188 1961 2223 2011 2189 2018
2216 2069 2218 2015 2233 2814 2283 1987
;;;;
run;quit;

/*
 SD1.BSFREQUENT total obs=60

  Obs    BUYS    SELLS

    1    2279     2009
    2    2166     2065
    3    2180     2002
  ...
   58    2218     2015
   59    2233     2814
   60    2283     1987
*/


data sd1.BSfrequent2015;
  retain date '31DEC2014'd;
  format date yymmdd10.;
  input buys sells @@;
  date=date+1;
cards4;
872 1669 1769 1655 2413 1664 1827 2302 1782 1701 1794 1678 1785 1683 1809 1738
1814 1699 1776 1675 2353 1685 1898 1686 1798 1769 1819 2227 1828 1653 1792 1715
1765 1779 1904 1677 2467 1606 1793 1628 2350 1657 1818 1670 1838 1691 1795 1728
1782 1659 1767 1679 1775 1716 1817 1702 1752 1686 2317 1748 1810 2266 1819 1711
1735 1675 1826 1660 1852 1737 1790 2163 1793 1711 1789 1629 1869 1645 1793 1676
1763 1781 1780 2335 1803 1667 1810 1707 1763 2249 2440 1709 1810 1718 1799 2312
1801 2171 1833 1741 1814 1662 1810 1616 1775 2192 2436 1671 1840 1767 1848 1645
1758 1671 2375 1666 1741 1676 1789 1723 1821 1726 1783 2354 1790 1733 1814 1734
2438 1702 1816 1681 1875 1663 2389 1710 1809 1702 1862 1650 1802 1711 1852 1778
1757 1667 1800 1634 1769 1711 1793 1772 1750 1714 1757 1705 1800 1710 1836 1727
1772 1747 1792 1668 2528 1661 1803 1687 1757 1702 1803 1660 1778 2379 1766 1719
1861 1690 1827 1769 1759 1702 1748 1732 1844 1679 1821 1606 1822 1694 2374 1676
1793 1725 1790 1681 1802 1639 1785 1691 1897 1746 1826 1700 1829 1747 1800 1675
1799 2255 1768 1710 1701 1596 1848 1700 1834 1618 1750 1676 2466 1703 1840 1820
1800 1717 1771 1636 1785 1711 1763 1799 1810 1657 1818 1632 1865 1733 1814 1746
1788 1695 1848 1721 1787 1654 1840 1657 1765 1698 1832 1739 1750 1682 1839 1677
1810 1671 1848 1746 1809 1716 1775 1729 1782 1670 1843 1732 2377 1710 1763 2301
2452 1732 1802 1770 1826 2357 1742 2294 1837 1683 1871 1664 2404 1669 1790 1737
1793 2235 1751 2300 1830 1757 1909 1694 1765 1771 1817 1728 1761 1738 1777 2351
1930 1689 1799 2319 1811 1675 1888 1715 1814 1753 1808 2381 1799 2374 1849 1762
1794 1690 1784 2372 2424 1708 1784 1652 1796 1721 2403 1722 1806 1682 1822 1688
1757 1749 1720 1700 1829 1760 2413 1699 1864 1700 1802 1732 1825 1700 1802 2310
1800 1742 2449 1684 1863 1729 1754 1682 1832 1779 1811 1715 1867 1756 1771 1695
2451 1611 1771 1704 1766 1727 1760 1671 2416 1659 1777 1638 1791 1690 1710 1674
2431 1768 2386 1728 1826 1699 1831 1649 1840 1714 1876 1663 1764 1693 1882 1741
1768 1665 1777 1690 1773 1694 1774 1761 2361 1589 1859 1695 1776 1714 1810 1653
1808 1715 1756 1729 1773 1706 1747 1677 1821 1715 1772 1703 1806 1651 1770 1721
1751 1739 1765 1696 1778 1715 1769 1725 1841 1774 1853 1685 1862 1656 1814 1716
1789 1698 1821 2285 2377 1719 1864 1668 1846 1699 1775 1671 1839 1752 1753 1723
1747 1752 1900 1687 1841 2291 1826 1656 1767 1686 1846 1671 1863 1692 1748 2334
1787 1711 1811 1726 1826 1774 1808 1622 1771 1644 1799 1692 1862 1654 1830 1720
1814 2257 1766 1665 2412 1722 1808 1689 1850 1722 1847 1729 1789 1668 1753 1692
1734 1762 2479 1669 1830 1775 2442 1682 1764 1784
;;;;
run;quit;


/*
SD1.BSFREQUENT2015 total obs=261

Obs       DATE       BUYS    SELLS

  1    2015-01-01     872     1669
  2    2015-01-02    1769     1655
  3    2015-01-03    2413     1664
  4    2015-01-04    1827     2302
....
*/

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

*____ ____   __                                 _
| __ ) ___| / _|_ __ ___  __ _ _   _  ___ _ __ | |_
|  _ \___ \| |_| '__/ _ \/ _` | | | |/ _ \ '_ \| __|
| |_) |__) |  _| | |  __/ (_| | |_| |  __/ | | | |_
|____/____/|_| |_|  \___|\__, |\__,_|\___|_| |_|\__|
                            |_|
;

%utl_submit_r64('
library(pinbasic);
library(haven);
library(SASxport);
BSfrequent<-as.data.frame(read_sas("d:/sd1/BSfrequent.sas7bdat"));
pin_freq <- pin_est(numbuys = BSfrequent[,"BUYS"], numsells = BSfrequent[,"SELLS"]);
stats<-as.data.frame(cbind(pin_freq$ll,pin_freq$pin,pin_freq$conv,pin_freq$message,pin_freq$iterations));
colnames(stats) <- c(names(pin_freq$ll),names(pin_freq$pin),names(pin_freq$conv),
  names(pin_freq$message),names(pin_freq$iterations));
stats[]<-lapply(stats, function(x) if(is.factor(x)) as.character(x) else x);
inits<-as.data.frame(cbind(pin_freq$init_vals[[1]],pin_freq$init_vals[[2]],pin_freq$init_vals[[3]],
  pin_freq$init_vals[[4]],pin_freq$init_vals[[5]]));
colnames(inits) <- c(names(pin_freq$init_vals[1]),names(pin_freq$init_vals[2]),names(pin_freq$init_vals[3]),
 names(pin_freq$init_vals[4]),names(pin_freq$init_vals[5]));
results<-as.data.frame(cbind(pin_freq$Results));
results$cat<-rownames(pin_freq$Results);
posterior<-as.data.frame(pin_freq$posterior);
write.xport(results,stats,inits,posterior,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";

data _null_;
  do dat='results  ','stats','inits','posterio';
    call symputx('dat',dat);
    rc=dosubl('
       data &dat;
         set xpt.&dat;
       run;quit;
       proc print data=&dat;
       title "Table &dat";
       %sysfunc(ifc(&dat=posterio,%str(format _numeric_ E18.12;),,));
       run;quit;
    ');
  end;
  stop;
run;quit;

WORK.RESULTS

   CAT        ESTIMATE    STD__ERR    T_VALUE       PR___T_

   alpha          0.20      0.0516      3.873    .000107477
   delta          0.50      0.1443      3.464    .000531979
   epsilon_b   2208.86      6.2619    352.746    .000000000
   epsilon_s   2003.65      5.9883    334.593    .000000000
   mu           816.50     16.1673     50.503    .000000000


 WORK.STATS

   LOGLIKELIHOOD              PIN            CONVERGE            ITERATIO

  1758333.24165194    0.0373189471517835       0        relative convergence (4)


 WORK.inits  (initial values)

  ALPHA    DELTA     EPSILO    EPSILO_1       MU

   0.2      0.5     2210.44     2001.96    816.380


 WORK.POSTERIO

 Obs                    NO                  GOOD                   BAD

   1     1.00000000000E+00     6.31707955267E-43     3.65136342119E-56
   2     1.00000000000E+00     1.40047268142E-58     2.75384406510E-48
   3     1.00000000000E+00     2.00788294823E-58     2.30697575896E-57
 ....
  58     1.00000000000E+00     7.11532397957E-52     4.18950232778E-57
  59     6.03227830002E-61                     .     1.00000000000E+00
  60     1.00000000000E+00     5.21562963414E-43     9.49303984758E-60


*    _                 _       _   _
 ___(_)_ __ ___  _   _| | __ _| |_(_) ___  _ __
/ __| | '_ ` _ \| | | | |/ _` | __| |/ _ \| '_ \
\__ \ | | | | | | |_| | | (_| | |_| | (_) | | | |
|___/_|_| |_| |_|\__,_|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_r64('
library(pinbasic);
library(haven);
library(SASxport);
data("BSfrequent2015");
BSfrequent215<-as.data.frame(read_sas("d:/sd1/BSfrequent.sas7bdat"));
qpin2015 <- qpin(numbuys = BSfrequent2015[,"Buys"], numsells = BSfrequent2015[,"Sells"],
                 dates = as.Date(rownames(BSfrequent2015), format = "%Y-%m-%d"),
                 confint = TRUE, ci_control = list(n = 1000, seed = 123));
inits<-as.data.frame(rbind(qpin2015$`2015.2`$init_vals,qpin2015$`2015.3`$init_vals,qpin2015$`2015.4`$init_vals));
confint<-as.data.frame(rbind(qpin2015$`2015.2`$confint,qpin2015$`2015.3`$confint,qpin2015$`2015.4`$confint));
ll<-as.data.frame(rbind(qpin2015$`2015.2`$ll,qpin2015$`2015.3`$ll,qpin2015$`2015.4`$ll));
pin<-as.data.frame(rbind(qpin2015$`2015.2`$pin,qpin2015$`2015.3`$pin,qpin2015$`2015.4`$pin));
conv<-as.data.frame(rbind(qpin2015$`2015.2`$conv,qpin2015$`2015.3`$conv,qpin2015$`2015.4`$conv));
message<-as.data.frame(rbind(qpin2015$`2015.2`$message,qpin2015$`2015.3`$message,qpin2015$`2015.4`$ll));
posterior<-as.data.frame(rbind(qpin2015$`2015.2`$posterior,qpin2015$`2015.3`$posterior,qpin2015$`2015.4`$posterior));
iteration<-as.data.frame(rbind(qpin2015$`2015.2`$iteration,qpin2015$`2015.3`$iteration,qpin2015$`2015.4`$iteration));
Results<-as.data.frame(rbind(qpin2015$`2015.2`$Results,qpin2015$`2015.3`$Results,qpin2015$`2015.4`$Results));
write.xport(Results,ll,pin,conv,message,iteration,inits,confint,posterior,file="d:/xpt/want.xpt");
');


* convert to SAS datasets;

libname xpt xport "d:/xpt/want.xpt";

proc contents data=xpt._all_;
run;quit;

data _null_;
  do dat='Results  ','ll','pin','conv','message','iteratio','inits','confint','posterio';
    call symputx('dat',dat);
    rc=dosubl('
       data &dat;
         set xpt.&dat;
       run;quit;
    ');
  end;
  stop;
run;quit;

* add quarter - could be done in R but with 'lots of code?';
data mrg;
  retain quarter;
  merge  pin conv message iteratio inits confint ll;
  select (_n_);
    when (2) quarter=2;
    when (3) quarter=3;
    when (4) quarter=4;
  end;
  rename
    loglike=logliklihood
    x2_5_  = pct_2_5
    x97_5_ = pct_97_5
  ;
run;quit;

 WORK.MRG total obs=3

 QUARTER       PIN      CONVERGE    LOGLIKLIHOOD    ITERATIO     ALPHA      DELTA      EPSILO    EPSILO_1       MU       PCT_2_5    PCT_97_5

    2       0.019066        0        1504936.86         1       0.10769    0.28571    1802.97     1696.52    631.588    0.006405    0.033146
    3       0.055083        0        1604954.72         1       0.33333    0.50000    1804.96     1710.80    614.845    0.036587    0.073228
    4       0.022863        0        1537816.61         4       0.13636    0.44444    1804.75     1700.32    601.438    0.010149    0.037943

* add rownames and quarters - hidden in R - and pain to extract inside R;
data results_fis;
  retain quarter coef;
  array coefs[15] $24 _temporary_ ('alpha','delta','epsilon_b','epsilon_s','mu',
                        'alpha','delta','epsilon_b','epsilon_s','mu',
                        'alpha','delta','epsilon_b','epsilon_s','mu');
  array quarters[15] _temporary_  (2,2,2,2,2,
                    3,3,3,3,3,
                    4,4,4,4,4);
  set results;
  quarter=quarters[_n_];
  coef=coefs[_n_];
run;quit;

WORK.RESULTS_FIS total obs=15

   QUARTER    COEF         ESTIMATE    STD__ERR    T_VALUE     PR___T_

      2       alpha            0.11      0.0384      2.801    0.005093
      2       delta            0.29      0.1707      1.673    0.094261
      2       epsilon_b     1802.98      5.4343    331.776    0.000000
      2       epsilon_s     1696.51      5.1565    329.006    0.000000
      2       mu             631.59     19.3789     32.591     .

      3       alpha            0.33      0.0580      5.745    0.000000
      3       delta            0.50      0.1066      4.690    0.000003
      3       epsilon_b     1804.96      5.5427    325.648    0.000000
      3       epsilon_s     1710.81      5.4051    316.520    0.000000

      3       mu             614.85     11.1177     55.304    0.000000
      4       alpha            0.14      0.0422      3.228    0.001245
      4       delta            0.44      0.1656      2.683    0.007290
      4       epsilon_b     1805.21      5.3639    336.546    0.000000
      4       epsilon_s     1699.85      5.1683    328.900    0.000000
      4       mu             601.41     16.4712     36.513     .


