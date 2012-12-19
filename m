From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [infiniband:for-next 2/6]
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27: sparse: cast from
 restricted __be16
Date: Thu, 20 Dec 2012 04:58:31 +0800
Message-ID: <50d22a77.9ZmVIIhoLpKw6mqa%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
head:   4d4b72d11156c560d4a97a20ba4dcda1ee7c976f
commit: dca4faeb812f665dab0607d8e0660ae564387186 [2/6] cxgb4: Add LE hash collision bug fix path in LLD driver


sparse warnings:

+ drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27: sparse: cast from restricted __be16
+ drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27: sparse: incorrect type in argument 1 (different base types)
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27:    expected unsigned short [unsigned] [usertype] val
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27:    got restricted __be16 [usertype] sport
+ drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27: sparse: cast from restricted __be16
+ drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:27: sparse: cast from restricted __be16
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:25: sparse: incorrect type in assignment (different base types)
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:25:    expected unsigned short [unsigned] [usertype] lport
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3335:25:    got restricted __be16 [usertype] <noident>

vim +3335 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c

dca4faeb Vipul Pandya 2012-12-10  3319  
dca4faeb Vipul Pandya 2012-12-10  3320  	/* Check to make sure the filter requested is writable ...
dca4faeb Vipul Pandya 2012-12-10  3321  	 */
dca4faeb Vipul Pandya 2012-12-10  3322  	f = &adap->tids.ftid_tab[stid];
dca4faeb Vipul Pandya 2012-12-10  3323  	ret = writable_filter(f);
dca4faeb Vipul Pandya 2012-12-10  3324  	if (ret)
dca4faeb Vipul Pandya 2012-12-10  3325  		return ret;
dca4faeb Vipul Pandya 2012-12-10  3326  
dca4faeb Vipul Pandya 2012-12-10  3327  	/* Clear out any old resources being used by the filter before
dca4faeb Vipul Pandya 2012-12-10  3328  	 * we start constructing the new filter.
dca4faeb Vipul Pandya 2012-12-10  3329  	 */
dca4faeb Vipul Pandya 2012-12-10  3330  	if (f->valid)
dca4faeb Vipul Pandya 2012-12-10  3331  		clear_filter(adap, f);
dca4faeb Vipul Pandya 2012-12-10  3332  
dca4faeb Vipul Pandya 2012-12-10  3333  	/* Clear out filter specifications */
dca4faeb Vipul Pandya 2012-12-10  3334  	memset(&f->fs, 0, sizeof(struct ch_filter_specification));
dca4faeb Vipul Pandya 2012-12-10 @3335  	f->fs.val.lport = cpu_to_be16(sport);
dca4faeb Vipul Pandya 2012-12-10  3336  	f->fs.mask.lport  = ~0;
dca4faeb Vipul Pandya 2012-12-10  3337  	val = (u8 *)&sip;
dca4faeb Vipul Pandya 2012-12-10  3338  	if ((val[0] | val[1] | val[2] | val[3]) != 0)
dca4faeb Vipul Pandya 2012-12-10  3339  		for (i = 0; i < 4; i++) {
dca4faeb Vipul Pandya 2012-12-10  3340  			f->fs.val.lip[i] = val[i];
dca4faeb Vipul Pandya 2012-12-10  3341  			f->fs.mask.lip[i] = ~0;
dca4faeb Vipul Pandya 2012-12-10  3342  		}
dca4faeb Vipul Pandya 2012-12-10  3343  

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
