From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 03/11] libbnxtre: Add support for CQ and QP
 management
Date: Sun, 29 Jan 2017 16:07:45 -0700
Message-ID: <20170129230745.GC24051@obsidianresearch.com>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-4-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-4-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2017 at 05:13:34PM -0500, Devesh Sharma wrote:

> diff --git a/providers/bnxtre/CMakeLists.txt b/providers/bnxtre/CMakeLists.txt
> index 4c61355..93bdf1a 100644
> +++ b/providers/bnxtre/CMakeLists.txt
> @@ -1,4 +1,5 @@
>  rdma_provider(bnxtre
> +	memory.c
>  	main.c
>  	verbs.c

Keep list sorted

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
