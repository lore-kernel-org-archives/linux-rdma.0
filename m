From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 01/10] DFSSSP: fix a memory leak in dfsssp_build_graph
Date: Sun, 3 Feb 2013 19:51:53 +0200
Message-ID: <20130203175153.GE2534@calypso.mtl.com>
References: <1358872698-16850-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1358872698-16850-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jens,

On 01:38 Wed 23 Jan     , Jens Domke wrote:
> If the graph could not be build correctly and DFSSSP returns an error, then not all allocated memory was freed.
> 
> Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
> ---

Applied the series, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
