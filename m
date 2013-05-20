From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libibverbs v5 5/7] libibverbs: Add ibv_open_qp
Date: Mon, 20 May 2013 12:13:21 -0500
Message-ID: <519A59B1.9080402@opengridcomputing.com>
References: <1364332466-22786-1-git-send-email-sean.hefty@intel.com> <1364332466-22786-6-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364332466-22786-6-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/26/2013 4:14 PM, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> XRC receive QPs are shareable across multiple processes.  Allow
> any process with access to the xrc domain to open an existing
> QP.  After opening the QP, the process will receive events
> related to the QP and be able to modify the QP.
>

Hey Sean,

So is it intended that cooperating processes sharing an xrc domain will 
"choose" one process to create the xrc qp, and the rest will open it?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
