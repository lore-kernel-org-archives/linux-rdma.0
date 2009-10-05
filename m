From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Mon, 5 Oct 2009 11:08:51 -0700
Message-ID: <F7D418716F3A4A0DACE42CC449624298@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <20091005175656.GK5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091005175656.GK5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>On Mon, Oct 05, 2009 at 10:43:44AM -0700, Sean Hefty wrote:
>> Export rdma_set_ib_paths to user space to allow applications to
>> manually set the IB path used for connections.  This allows
>> alternative ways for a user space application or library to obtain
>> path record information, including retrieving path information
>> from cached data, avoiding direct interaction with the IB SA.
>> The IB SA is a single, centralized entity that can limit scaling
>> on large clusters running MPI applications.
>
>Um, isn't this kind of low level control exactly why we have the IB
>CM?

There are very few apps that I'm aware of (one to be precise) that have coded
directly to the libibcm.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
