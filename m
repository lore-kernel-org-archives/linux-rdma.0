From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Thu, 14 Jan 2016 19:40:14 +0200
Message-ID: <20160114174014.GA30615@leon.nu>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
 <00d301d14d69$18257d70$48707850$@opengridcomputing.com>
 <CAAKD3BAWUfg6sVLCEtb-vBrC9kGtVYO784xg4_tGqiZaOVh-2Q@mail.gmail.com>
 <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com>
 <56974AEE.6060201@mellanox.com>
 <004401d14edb$65c6b260$31541720$@opengridcomputing.com>
 <5697B80E.5090903@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5697B80E.5090903-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 14, 2016 at 05:00:30PM +0200, Or Gerlitz wrote:
> On 1/14/2016 4:53 PM, Steve Wise wrote:
> >Hey Or, iWARP is non-functional in 4.4, and this patch fixes the regression.  I suggest we get this fix in stable asap.
> 
> sure, we can make an exception in our usual track for this one, but you need
> upstream commit ID ## -- Doug is your key person here

Or, there are no doubts that commit ID is important for our work, however
submission to stable can be done without it [1].

Just follow the Steve's advice on cc-ing stable list in sign-off section.

[1] http://lxr.free-electrons.com/source/Documentation/stable_kernel_rules.txt#L40

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
