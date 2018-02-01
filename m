From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] RDMA/hns: Fix the endian problem for hns
Date: Fri, 2 Feb 2018 07:12:47 +0800
Message-ID: <201802020744.ndxb7J1y%fengguang.wu@intel.com>
References: <1517314845-126094-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517314845-126094-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Lijun,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on next-20180201]
[cannot apply to v4.15]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Lijun-Ou/Fixes-for-hns/20180202-014309
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: sparse: incorrect type in assignment (different base types) @@ expected unsigned int doorbell_qpn @@ got ed int doorbell_qpn @@
   drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: expected unsigned int doorbell_qpn
   drivers/infiniband/hw/hns/hns_roce_qp.c:699:37: got restricted __le64 <noident>
--
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1227:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1227:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1227:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1259:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1266:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1497:29: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1498:34: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1500:34: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1502:39: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1556:36: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1571:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1573:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1579:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1581:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1678:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1680:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1682:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1683:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1684:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1687:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1687:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1687:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1688:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1688:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1688:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1689:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1689:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1689:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1693:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1693:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1693:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1716:18: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1716:18: sparse: cast from restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1785:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1800:9: right side has type restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1847:32: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 virt_addr_l @@ got unsignrestricted __le32 virt_addr_l @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1847:32: expected restricted __le32 virt_addr_l
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1847:32: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1848:32: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 virt_addr_h @@ got unsignrestricted __le32 virt_addr_h @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1848:32: expected restricted __le32 virt_addr_h
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1848:32: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1849:27: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 length @@ got unsignrestricted __le32 length @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1849:27: expected restricted __le32 length
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1849:27: got unsigned int <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1881:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1887:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1891:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1897:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1901:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1907:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1911:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1918:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1924:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1928:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1934:25: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1938:25: sparse: cast from restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1950:31: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 pbl_addr_l @@ got unsignrestricted __le32 pbl_addr_l @@
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1950:31: expected restricted __le32 pbl_addr_l
   drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1950:31: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1985:9: sparse: too many warnings
--
>> drivers/infiniband/hw/hns/hns_roce_main.c:203:31: sparse: incorrect type in assignment (different base types) @@ expected restricted __be64 sys_image_guid @@ got restricted __be64 sys_image_guid @@
   drivers/infiniband/hw/hns/hns_roce_main.c:203:31: expected restricted __be64 sys_image_guid
   drivers/infiniband/hw/hns/hns_roce_main.c:203:31: got restricted __be32 <noident>
--
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:479:37: sparse: incorrect type in argument 1 (different base types) @@ expected restricted __be32 @@ got restricted __be32 @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:479:37: expected restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:479:37: got restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:574:37: sparse: incorrect type in argument 1 (different base types) @@ expected restricted __be32 @@ got restricted __be32 @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:574:37: expected restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:574:37: got restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:802:18: sparse: restricted __le16 degrades to integer
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:819:34: sparse: incorrect type in assignment (different base types) @@ expected unsigned short desc_ret @@ got short desc_ret @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:819:34: expected unsigned short desc_ret
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:819:34: got restricted __le16 retval
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:858:26: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:858:26: sparse: cast from restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:859:29: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:859:29: sparse: cast from restricted __le16
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1219:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1221:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1223:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1225:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1228:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1228:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1228:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1229:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1229:22: expected unsigned long val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1229:22: got restricted __le64 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1234:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1234:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1234:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1235:22: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1235:22: expected unsigned int val
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1235:22: got restricted __le32 <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1305:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1326:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1357:39: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1371:39: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1375:36: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1392:38: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1418:36: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1429:38: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1476:33: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1600:38: sparse: cast from restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1605:38: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 cqe_cur_blk_addr @@ got unsignrestricted __le32 cqe_cur_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1605:38: expected restricted __le32 cqe_cur_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1605:38: got unsigned int <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1607:33: sparse: cast from restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1609:9: sparse: cast from restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1618:38: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 cqe_nxt_blk_addr @@ got unsignrestricted __le32 cqe_nxt_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1618:38: expected restricted __le32 cqe_nxt_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1618:38: got unsigned int <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1619:9: sparse: cast from restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1632:28: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 cqe_ba @@ got unsignrestricted __le32 cqe_ba @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1632:28: expected restricted __le32 cqe_ba
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1632:28: got unsigned int <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1663:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1665:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1667:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1670:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1672:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1675:28: sparse: incorrect type in argument 1 (different base types) @@ expected restricted __be32 @@ got 2 @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1675:28: expected restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1675:28: got unsigned int
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2269:36: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 qkey_xrcd @@ got unsigned intrestricted __le32 qkey_xrcd @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2269:36: expected restricted __le32 qkey_xrcd
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2269:36: got unsigned int const qkey
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2583:36: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 qkey_xrcd @@ got unsigned intrestricted __le32 qkey_xrcd @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2583:36: expected restricted __le32 qkey_xrcd
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2583:36: got unsigned int const qkey
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2657:29: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 wqe_sge_ba @@ got unsignrestricted __le32 wqe_sge_ba @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2657:29: expected restricted __le32 wqe_sge_ba
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2657:29: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2720:34: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 rq_cur_blk_addr @@ got unsignrestricted __le32 rq_cur_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2720:34: expected restricted __le32 rq_cur_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2720:34: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2733:34: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 rq_nxt_blk_addr @@ got unsignrestricted __le32 rq_nxt_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2733:34: expected restricted __le32 rq_nxt_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2733:34: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2757:26: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 trrl_ba @@ got unsignrestricted __le32 trrl_ba @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2757:26: expected restricted __le32 trrl_ba
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2757:26: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2765:26: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 irrl_ba @@ got unsignrestricted __le32 irrl_ba @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2765:26: expected restricted __le32 irrl_ba
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2765:26: got unsigned int <noident>
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2776:9: sparse: cast from restricted __le32
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2944:34: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 sq_cur_blk_addr @@ got unsignrestricted __le32 sq_cur_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2944:34: expected restricted __le32 sq_cur_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2944:34: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2955:38: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 sq_cur_sge_blk_addr @@ got sq_cur_sge_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2955:38: expected restricted __le32 sq_cur_sge_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2955:38: got unsigned int
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2970:37: sparse: incorrect type in assignment (different base types) @@ expected restricted __le32 rx_sq_cur_blk_addr @@ got unsignrestricted __le32 rx_sq_cur_blk_addr @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2970:37: expected restricted __le32 rx_sq_cur_blk_addr
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2970:37: got unsigned int <noident>
>> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3368:28: sparse: incorrect type in assignment (different base types) @@ expected unsigned char rnr_retry @@ got d char rnr_retry @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3368:28: expected unsigned char rnr_retry
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3368:28: got restricted __le32 rq_rnr_timer
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3521:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3527:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3530:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3537:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3541:28: sparse: incorrect type in argument 1 (different base types) @@ expected restricted __be32 @@ got 2 @@
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3541:28: expected restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3541:28: got unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3552:20: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3583:20: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3620:15: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3654:15: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3710:17: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3729:30: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3828:20: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3847:23: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3895:13: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3898:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3901:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3905:20: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3908:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3911:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3915:20: sparse: cast to restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3918:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hw_v2.c:3921:17: right side has type restricted __le32
--
>> drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:300:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:304:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:309:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:313:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:320:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:322:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:323:9: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: sparse: invalid assignment: &=
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: sparse: invalid assignment: |=
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: left side has type unsigned int
   drivers/infiniband/hw/hns/hns_roce_hem.c:349:17: right side has type restricted __le32
   drivers/infiniband/hw/hns/hns_roce_hem.c:355:36: sparse: incorrect type in argument 1 (different base types) @@ expected restricted __be32 @@ got 2 @@
   drivers/infiniband/hw/hns/hns_roce_hem.c:355:36: expected restricted __be32
   drivers/infiniband/hw/hns/hns_roce_hem.c:355:36: got unsigned int

vim +699 drivers/infiniband/hw/hns/hns_roce_qp.c

9a4435375c oulijun        2016-07-21  491  
9a4435375c oulijun        2016-07-21  492  static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
9a4435375c oulijun        2016-07-21  493  				     struct ib_pd *ib_pd,
9a4435375c oulijun        2016-07-21  494  				     struct ib_qp_init_attr *init_attr,
9a4435375c oulijun        2016-07-21  495  				     struct ib_udata *udata, unsigned long sqpn,
9a4435375c oulijun        2016-07-21  496  				     struct hns_roce_qp *hr_qp)
9a4435375c oulijun        2016-07-21  497  {
13ca970e36 Wei Hu(Xavier  2017-08-30  498) 	struct device *dev = hr_dev->dev;
9a4435375c oulijun        2016-07-21  499  	struct hns_roce_ib_create_qp ucmd;
9a4435375c oulijun        2016-07-21  500  	unsigned long qpn = 0;
9a4435375c oulijun        2016-07-21  501  	int ret = 0;
9a8982dc89 Wei Hu(Xavier  2017-10-18  502) 	u32 page_shift;
9a8982dc89 Wei Hu(Xavier  2017-10-18  503) 	u32 npages;
0009c2dbe8 oulijun        2018-01-03  504  	int i;
9a4435375c oulijun        2016-07-21  505  
9a4435375c oulijun        2016-07-21  506  	mutex_init(&hr_qp->mutex);
9a4435375c oulijun        2016-07-21  507  	spin_lock_init(&hr_qp->sq.lock);
9a4435375c oulijun        2016-07-21  508  	spin_lock_init(&hr_qp->rq.lock);
9a4435375c oulijun        2016-07-21  509  
9a4435375c oulijun        2016-07-21  510  	hr_qp->state = IB_QPS_RESET;
9a4435375c oulijun        2016-07-21  511  
b66efc9320 oulijun        2018-01-10  512  	hr_qp->ibqp.qp_type = init_attr->qp_type;
b66efc9320 oulijun        2018-01-10  513  
9a4435375c oulijun        2016-07-21  514  	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
b61a3016b4 Lijun Ou       2018-01-30  515  		hr_qp->sq_signal_bits = cpu_to_le32(IB_SIGNAL_ALL_WR);
9a4435375c oulijun        2016-07-21  516  	else
b61a3016b4 Lijun Ou       2018-01-30  517  		hr_qp->sq_signal_bits = cpu_to_le32(IB_SIGNAL_REQ_WR);
9a4435375c oulijun        2016-07-21  518  
9a4435375c oulijun        2016-07-21  519  	ret = hns_roce_set_rq_size(hr_dev, &init_attr->cap, !!ib_pd->uobject,
9a4435375c oulijun        2016-07-21  520  				   !!init_attr->srq, hr_qp);
9a4435375c oulijun        2016-07-21  521  	if (ret) {
9a4435375c oulijun        2016-07-21  522  		dev_err(dev, "hns_roce_set_rq_size failed\n");
9a4435375c oulijun        2016-07-21  523  		goto err_out;
9a4435375c oulijun        2016-07-21  524  	}
9a4435375c oulijun        2016-07-21  525  
0009c2dbe8 oulijun        2018-01-03  526  	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE) {
0009c2dbe8 oulijun        2018-01-03  527  		/* allocate recv inline buf */
0009c2dbe8 oulijun        2018-01-03  528  		hr_qp->rq_inl_buf.wqe_list = kcalloc(hr_qp->rq.wqe_cnt,
0009c2dbe8 oulijun        2018-01-03  529  					       sizeof(struct hns_roce_rinl_wqe),
0009c2dbe8 oulijun        2018-01-03  530  					       GFP_KERNEL);
0009c2dbe8 oulijun        2018-01-03  531  		if (!hr_qp->rq_inl_buf.wqe_list) {
0009c2dbe8 oulijun        2018-01-03  532  			ret = -ENOMEM;
0009c2dbe8 oulijun        2018-01-03  533  			goto err_out;
0009c2dbe8 oulijun        2018-01-03  534  		}
0009c2dbe8 oulijun        2018-01-03  535  
0009c2dbe8 oulijun        2018-01-03  536  		hr_qp->rq_inl_buf.wqe_cnt = hr_qp->rq.wqe_cnt;
0009c2dbe8 oulijun        2018-01-03  537  
0009c2dbe8 oulijun        2018-01-03  538  		/* Firstly, allocate a list of sge space buffer */
0009c2dbe8 oulijun        2018-01-03  539  		hr_qp->rq_inl_buf.wqe_list[0].sg_list =
0009c2dbe8 oulijun        2018-01-03  540  					kcalloc(hr_qp->rq_inl_buf.wqe_cnt,
0009c2dbe8 oulijun        2018-01-03  541  					       init_attr->cap.max_recv_sge *
0009c2dbe8 oulijun        2018-01-03  542  					       sizeof(struct hns_roce_rinl_sge),
0009c2dbe8 oulijun        2018-01-03  543  					       GFP_KERNEL);
0009c2dbe8 oulijun        2018-01-03  544  		if (!hr_qp->rq_inl_buf.wqe_list[0].sg_list) {
0009c2dbe8 oulijun        2018-01-03  545  			ret = -ENOMEM;
0009c2dbe8 oulijun        2018-01-03  546  			goto err_wqe_list;
0009c2dbe8 oulijun        2018-01-03  547  		}
0009c2dbe8 oulijun        2018-01-03  548  
0009c2dbe8 oulijun        2018-01-03  549  		for (i = 1; i < hr_qp->rq_inl_buf.wqe_cnt; i++)
0009c2dbe8 oulijun        2018-01-03  550  			/* Secondly, reallocate the buffer */
0009c2dbe8 oulijun        2018-01-03  551  			hr_qp->rq_inl_buf.wqe_list[i].sg_list =
0009c2dbe8 oulijun        2018-01-03  552  				&hr_qp->rq_inl_buf.wqe_list[0].sg_list[i *
0009c2dbe8 oulijun        2018-01-03  553  				init_attr->cap.max_recv_sge];
0009c2dbe8 oulijun        2018-01-03  554  	}
0009c2dbe8 oulijun        2018-01-03  555  
9a4435375c oulijun        2016-07-21  556  	if (ib_pd->uobject) {
9a4435375c oulijun        2016-07-21  557  		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
9a4435375c oulijun        2016-07-21  558  			dev_err(dev, "ib_copy_from_udata error for create qp\n");
9a4435375c oulijun        2016-07-21  559  			ret = -EFAULT;
0009c2dbe8 oulijun        2018-01-03  560  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  561  		}
9a4435375c oulijun        2016-07-21  562  
926a01dc00 Wei Hu(Xavier  2017-08-30  563) 		ret = hns_roce_set_user_sq_size(hr_dev, &init_attr->cap, hr_qp,
926a01dc00 Wei Hu(Xavier  2017-08-30  564) 						&ucmd);
9a4435375c oulijun        2016-07-21  565  		if (ret) {
9a4435375c oulijun        2016-07-21  566  			dev_err(dev, "hns_roce_set_user_sq_size error for create qp\n");
0009c2dbe8 oulijun        2018-01-03  567  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  568  		}
9a4435375c oulijun        2016-07-21  569  
9a4435375c oulijun        2016-07-21  570  		hr_qp->umem = ib_umem_get(ib_pd->uobject->context,
9a4435375c oulijun        2016-07-21  571  					  ucmd.buf_addr, hr_qp->buff_size, 0,
9a4435375c oulijun        2016-07-21  572  					  0);
9a4435375c oulijun        2016-07-21  573  		if (IS_ERR(hr_qp->umem)) {
9a4435375c oulijun        2016-07-21  574  			dev_err(dev, "ib_umem_get error for create qp\n");
9a4435375c oulijun        2016-07-21  575  			ret = PTR_ERR(hr_qp->umem);
0009c2dbe8 oulijun        2018-01-03  576  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  577  		}
9a4435375c oulijun        2016-07-21  578  
9766edc34e Shaobo Xu      2017-08-30  579  		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
9a8982dc89 Wei Hu(Xavier  2017-10-18  580) 		if (hr_dev->caps.mtt_buf_pg_sz) {
9a8982dc89 Wei Hu(Xavier  2017-10-18  581) 			npages = (ib_umem_page_count(hr_qp->umem) +
9a8982dc89 Wei Hu(Xavier  2017-10-18  582) 				  (1 << hr_dev->caps.mtt_buf_pg_sz) - 1) /
9a8982dc89 Wei Hu(Xavier  2017-10-18  583) 				  (1 << hr_dev->caps.mtt_buf_pg_sz);
9a8982dc89 Wei Hu(Xavier  2017-10-18  584) 			page_shift = PAGE_SHIFT + hr_dev->caps.mtt_buf_pg_sz;
9a8982dc89 Wei Hu(Xavier  2017-10-18  585) 			ret = hns_roce_mtt_init(hr_dev, npages,
9a8982dc89 Wei Hu(Xavier  2017-10-18  586) 				    page_shift,
9a8982dc89 Wei Hu(Xavier  2017-10-18  587) 				    &hr_qp->mtt);
9a8982dc89 Wei Hu(Xavier  2017-10-18  588) 		} else {
9a8982dc89 Wei Hu(Xavier  2017-10-18  589) 			ret = hns_roce_mtt_init(hr_dev,
9a8982dc89 Wei Hu(Xavier  2017-10-18  590) 				    ib_umem_page_count(hr_qp->umem),
9a8982dc89 Wei Hu(Xavier  2017-10-18  591) 				    hr_qp->umem->page_shift,
9a8982dc89 Wei Hu(Xavier  2017-10-18  592) 				    &hr_qp->mtt);
9a8982dc89 Wei Hu(Xavier  2017-10-18  593) 		}
9a4435375c oulijun        2016-07-21  594  		if (ret) {
9a4435375c oulijun        2016-07-21  595  			dev_err(dev, "hns_roce_mtt_init error for create qp\n");
9a4435375c oulijun        2016-07-21  596  			goto err_buf;
9a4435375c oulijun        2016-07-21  597  		}
9a4435375c oulijun        2016-07-21  598  
9a4435375c oulijun        2016-07-21  599  		ret = hns_roce_ib_umem_write_mtt(hr_dev, &hr_qp->mtt,
9a4435375c oulijun        2016-07-21  600  						 hr_qp->umem);
9a4435375c oulijun        2016-07-21  601  		if (ret) {
9a4435375c oulijun        2016-07-21  602  			dev_err(dev, "hns_roce_ib_umem_write_mtt error for create qp\n");
9a4435375c oulijun        2016-07-21  603  			goto err_mtt;
9a4435375c oulijun        2016-07-21  604  		}
9a4435375c oulijun        2016-07-21  605  	} else {
9a4435375c oulijun        2016-07-21  606  		if (init_attr->create_flags &
9a4435375c oulijun        2016-07-21  607  		    IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
9a4435375c oulijun        2016-07-21  608  			dev_err(dev, "init_attr->create_flags error!\n");
9a4435375c oulijun        2016-07-21  609  			ret = -EINVAL;
0009c2dbe8 oulijun        2018-01-03  610  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  611  		}
9a4435375c oulijun        2016-07-21  612  
9a4435375c oulijun        2016-07-21  613  		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO) {
9a4435375c oulijun        2016-07-21  614  			dev_err(dev, "init_attr->create_flags error!\n");
9a4435375c oulijun        2016-07-21  615  			ret = -EINVAL;
0009c2dbe8 oulijun        2018-01-03  616  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  617  		}
9a4435375c oulijun        2016-07-21  618  
9a4435375c oulijun        2016-07-21  619  		/* Set SQ size */
9a4435375c oulijun        2016-07-21  620  		ret = hns_roce_set_kernel_sq_size(hr_dev, &init_attr->cap,
76445703e5 Lijun Ou       2016-09-20  621  						  hr_qp);
9a4435375c oulijun        2016-07-21  622  		if (ret) {
9a4435375c oulijun        2016-07-21  623  			dev_err(dev, "hns_roce_set_kernel_sq_size error!\n");
0009c2dbe8 oulijun        2018-01-03  624  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  625  		}
9a4435375c oulijun        2016-07-21  626  
9a4435375c oulijun        2016-07-21  627  		/* QP doorbell register address */
2d40788825 Wei Hu(Xavier  2017-08-30  628) 		hr_qp->sq.db_reg_l = hr_dev->reg_base + hr_dev->sdb_offset +
9a4435375c oulijun        2016-07-21  629  				     DB_REG_OFFSET * hr_dev->priv_uar.index;
2d40788825 Wei Hu(Xavier  2017-08-30  630) 		hr_qp->rq.db_reg_l = hr_dev->reg_base + hr_dev->odb_offset +
9a4435375c oulijun        2016-07-21  631  				     DB_REG_OFFSET * hr_dev->priv_uar.index;
9a4435375c oulijun        2016-07-21  632  
9a4435375c oulijun        2016-07-21  633  		/* Allocate QP buf */
9a8982dc89 Wei Hu(Xavier  2017-10-18  634) 		page_shift = PAGE_SHIFT + hr_dev->caps.mtt_buf_pg_sz;
9a8982dc89 Wei Hu(Xavier  2017-10-18  635) 		if (hns_roce_buf_alloc(hr_dev, hr_qp->buff_size,
9a8982dc89 Wei Hu(Xavier  2017-10-18  636) 				       (1 << page_shift) * 2,
9a8982dc89 Wei Hu(Xavier  2017-10-18  637) 				       &hr_qp->hr_buf, page_shift)) {
9a4435375c oulijun        2016-07-21  638  			dev_err(dev, "hns_roce_buf_alloc error!\n");
9a4435375c oulijun        2016-07-21  639  			ret = -ENOMEM;
0009c2dbe8 oulijun        2018-01-03  640  			goto err_rq_sge_list;
9a4435375c oulijun        2016-07-21  641  		}
9a4435375c oulijun        2016-07-21  642  
9766edc34e Shaobo Xu      2017-08-30  643  		hr_qp->mtt.mtt_type = MTT_TYPE_WQE;
9a4435375c oulijun        2016-07-21  644  		/* Write MTT */
9a4435375c oulijun        2016-07-21  645  		ret = hns_roce_mtt_init(hr_dev, hr_qp->hr_buf.npages,
9a4435375c oulijun        2016-07-21  646  					hr_qp->hr_buf.page_shift, &hr_qp->mtt);
9a4435375c oulijun        2016-07-21  647  		if (ret) {
9a4435375c oulijun        2016-07-21  648  			dev_err(dev, "hns_roce_mtt_init error for kernel create qp\n");
9a4435375c oulijun        2016-07-21  649  			goto err_buf;
9a4435375c oulijun        2016-07-21  650  		}
9a4435375c oulijun        2016-07-21  651  
9a4435375c oulijun        2016-07-21  652  		ret = hns_roce_buf_write_mtt(hr_dev, &hr_qp->mtt,
9a4435375c oulijun        2016-07-21  653  					     &hr_qp->hr_buf);
9a4435375c oulijun        2016-07-21  654  		if (ret) {
9a4435375c oulijun        2016-07-21  655  			dev_err(dev, "hns_roce_buf_write_mtt error for kernel create qp\n");
9a4435375c oulijun        2016-07-21  656  			goto err_mtt;
9a4435375c oulijun        2016-07-21  657  		}
9a4435375c oulijun        2016-07-21  658  
9a4435375c oulijun        2016-07-21  659  		hr_qp->sq.wrid = kmalloc_array(hr_qp->sq.wqe_cnt, sizeof(u64),
9a4435375c oulijun        2016-07-21  660  					       GFP_KERNEL);
9a4435375c oulijun        2016-07-21  661  		hr_qp->rq.wrid = kmalloc_array(hr_qp->rq.wqe_cnt, sizeof(u64),
9a4435375c oulijun        2016-07-21  662  					       GFP_KERNEL);
9a4435375c oulijun        2016-07-21  663  		if (!hr_qp->sq.wrid || !hr_qp->rq.wrid) {
9a4435375c oulijun        2016-07-21  664  			ret = -ENOMEM;
9a4435375c oulijun        2016-07-21  665  			goto err_wrid;
9a4435375c oulijun        2016-07-21  666  		}
9a4435375c oulijun        2016-07-21  667  	}
9a4435375c oulijun        2016-07-21  668  
9a4435375c oulijun        2016-07-21  669  	if (sqpn) {
9a4435375c oulijun        2016-07-21  670  		qpn = sqpn;
9a4435375c oulijun        2016-07-21  671  	} else {
9a4435375c oulijun        2016-07-21  672  		/* Get QPN */
9a4435375c oulijun        2016-07-21  673  		ret = hns_roce_reserve_range_qp(hr_dev, 1, 1, &qpn);
9a4435375c oulijun        2016-07-21  674  		if (ret) {
9a4435375c oulijun        2016-07-21  675  			dev_err(dev, "hns_roce_reserve_range_qp alloc qpn error\n");
9a4435375c oulijun        2016-07-21  676  			goto err_wrid;
9a4435375c oulijun        2016-07-21  677  		}
9a4435375c oulijun        2016-07-21  678  	}
9a4435375c oulijun        2016-07-21  679  
926a01dc00 Wei Hu(Xavier  2017-08-30  680) 	if (init_attr->qp_type == IB_QPT_GSI &&
926a01dc00 Wei Hu(Xavier  2017-08-30  681) 	    hr_dev->hw_rev == HNS_ROCE_HW_VER1) {
926a01dc00 Wei Hu(Xavier  2017-08-30  682) 		/* In v1 engine, GSI QP context in RoCE engine's register */
9a4435375c oulijun        2016-07-21  683  		ret = hns_roce_gsi_qp_alloc(hr_dev, qpn, hr_qp);
9a4435375c oulijun        2016-07-21  684  		if (ret) {
9a4435375c oulijun        2016-07-21  685  			dev_err(dev, "hns_roce_qp_alloc failed!\n");
9a4435375c oulijun        2016-07-21  686  			goto err_qpn;
9a4435375c oulijun        2016-07-21  687  		}
9a4435375c oulijun        2016-07-21  688  	} else {
9a4435375c oulijun        2016-07-21  689  		ret = hns_roce_qp_alloc(hr_dev, qpn, hr_qp);
9a4435375c oulijun        2016-07-21  690  		if (ret) {
9a4435375c oulijun        2016-07-21  691  			dev_err(dev, "hns_roce_qp_alloc failed!\n");
9a4435375c oulijun        2016-07-21  692  			goto err_qpn;
9a4435375c oulijun        2016-07-21  693  		}
9a4435375c oulijun        2016-07-21  694  	}
9a4435375c oulijun        2016-07-21  695  
9a4435375c oulijun        2016-07-21  696  	if (sqpn)
9a4435375c oulijun        2016-07-21  697  		hr_qp->doorbell_qpn = 1;
9a4435375c oulijun        2016-07-21  698  	else
9a4435375c oulijun        2016-07-21 @699  		hr_qp->doorbell_qpn = cpu_to_le64(hr_qp->qpn);
9a4435375c oulijun        2016-07-21  700  
9a4435375c oulijun        2016-07-21  701  	hr_qp->event = hns_roce_ib_qp_event;
9a4435375c oulijun        2016-07-21  702  
9a4435375c oulijun        2016-07-21  703  	return 0;
9a4435375c oulijun        2016-07-21  704  
9a4435375c oulijun        2016-07-21  705  err_qpn:
9a4435375c oulijun        2016-07-21  706  	if (!sqpn)
9a4435375c oulijun        2016-07-21  707  		hns_roce_release_range_qp(hr_dev, qpn, 1);
9a4435375c oulijun        2016-07-21  708  
9a4435375c oulijun        2016-07-21  709  err_wrid:
9a4435375c oulijun        2016-07-21  710  	kfree(hr_qp->sq.wrid);
9a4435375c oulijun        2016-07-21  711  	kfree(hr_qp->rq.wrid);
9a4435375c oulijun        2016-07-21  712  
9a4435375c oulijun        2016-07-21  713  err_mtt:
9a4435375c oulijun        2016-07-21  714  	hns_roce_mtt_cleanup(hr_dev, &hr_qp->mtt);
9a4435375c oulijun        2016-07-21  715  
9a4435375c oulijun        2016-07-21  716  err_buf:
9a4435375c oulijun        2016-07-21  717  	if (ib_pd->uobject)
9a4435375c oulijun        2016-07-21  718  		ib_umem_release(hr_qp->umem);
9a4435375c oulijun        2016-07-21  719  	else
9a4435375c oulijun        2016-07-21  720  		hns_roce_buf_free(hr_dev, hr_qp->buff_size, &hr_qp->hr_buf);
9a4435375c oulijun        2016-07-21  721  
0009c2dbe8 oulijun        2018-01-03  722  err_rq_sge_list:
0009c2dbe8 oulijun        2018-01-03  723  	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE)
0009c2dbe8 oulijun        2018-01-03  724  		kfree(hr_qp->rq_inl_buf.wqe_list[0].sg_list);
0009c2dbe8 oulijun        2018-01-03  725  
0009c2dbe8 oulijun        2018-01-03  726  err_wqe_list:
0009c2dbe8 oulijun        2018-01-03  727  	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_RQ_INLINE)
0009c2dbe8 oulijun        2018-01-03  728  		kfree(hr_qp->rq_inl_buf.wqe_list);
0009c2dbe8 oulijun        2018-01-03  729  
9a4435375c oulijun        2016-07-21  730  err_out:
9a4435375c oulijun        2016-07-21  731  	return ret;
9a4435375c oulijun        2016-07-21  732  }
9a4435375c oulijun        2016-07-21  733  

:::::: The code at line 699 was first introduced by commit
:::::: 9a4435375cd151e07c0c38fa601b00115986091b IB/hns: Add driver files for hns RoCE driver

:::::: TO: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
:::::: CC: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
