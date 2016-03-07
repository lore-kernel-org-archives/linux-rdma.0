From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 04/10] IB/core: Support accessing SA in
 virtualized environment
Date: Mon, 7 Mar 2016 15:04:34 -0700
Message-ID: <20160307220434.GB6706@obsidianresearch.com>
References: <1457384940-11951-1-git-send-email-eli@mellanox.com>
 <1457384940-11951-5-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457384940-11951-5-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 07, 2016 at 11:08:54PM +0200, Eli Cohen wrote:

> +enum {
> +	IB_SA_WELL_KNOWN_GUID	= 2,
> +};

Where did this come from?

It is wrong to have a EUI-64 like this that has a 0 OUI.

It is wrong to have a 'well known GUID' that is by definition not
universal without setting the local bit (IBA spec even says this)

The well known guid should still conform to IEEE rules for creating
EUI-64s.

Note, that the IBA is a little confused because it tries to follow
IPv6 rules in some places not realizing that IPv6 uses an EUI-64 with
the U/L bit inverted.

IMHO, new constants should strictly follow the IEEE EUI-64 rules and
not try and confuse matters futher. The unused, incorrect, IBA
definition of ::1 should be ignored.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
