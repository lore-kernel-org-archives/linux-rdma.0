From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Thu, 14 Jan 2016 17:00:30 +0200
Message-ID: <5697B80E.5090903@mellanox.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
 <00d301d14d69$18257d70$48707850$@opengridcomputing.com>
 <CAAKD3BAWUfg6sVLCEtb-vBrC9kGtVYO784xg4_tGqiZaOVh-2Q@mail.gmail.com>
 <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com>
 <56974AEE.6060201@mellanox.com>
 <004401d14edb$65c6b260$31541720$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004401d14edb$65c6b260$31541720$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/14/2016 4:53 PM, Steve Wise wrote:
> Hey Or, iWARP is non-functional in 4.4, and this patch fixes the regression.  I suggest we get this fix in stable asap.

sure, we can make an exception in our usual track for this one, but you 
need upstream commit ID ## -- Doug is your key person here
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
