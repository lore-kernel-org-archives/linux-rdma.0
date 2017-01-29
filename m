From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/11] Broadcom User Space RoCE Driver
Date: Sun, 29 Jan 2017 15:56:25 -0700
Message-ID: <20170129225625.GA24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:31PM -0500, Devesh Sharma wrote:
> This series introduces the user space RoCE driver for the Broadcom
> NetXtreme-E 10/25/40/50 RDMA Ethernet Controller. This driver
> is dependent on the bnxt_re driver posted earlier to linux-rdma
> community and is under reveiw.
> 
> This patch series is based on the latest master of rdma-core
> repository hosted at https://github.com/linux-rdma/rdma-core.git
> 
> The GIT for this library is hosted at following URL on github
> https://github.com/dsharma283/bnxtre-rdma-core.git
> branch: bnxtre-v0

Please make a github pull request for this so we can see that travis
succeeds in building it.

You can keep it up to date with feedback using force-push to your branch.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
