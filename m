From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] OpenSM: DFSSSP does not find LIDs due to wrong byte
 order
Date: Sun, 3 Feb 2013 19:51:28 +0200
Message-ID: <20130203175128.GD2534@calypso.mtl.com>
References: <1355674013-3779-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1355674013-3779-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jens,

On 01:06 Mon 17 Dec     , Jens Domke wrote:
> Problem:
> path_sl(...) arguments for slid/dlid are in network byte order; internal storage of lids is host byte order; this mismatch results in a return value of 'hint_for_default_sl' of DFSSSP's get_dfsssp_sl function for every request
> 
> Fix:
> lids will be stored in network byte order, so that a conversion is not necessaryand DFSSSP returns the correct SL for tht request
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
