From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [RESEND] [PATCH/RFC] opensm: toggle sweeping
Date: Fri, 7 May 2010 01:14:46 +0300
Message-ID: <20100506221446.GK7099@me.iol.unh.edu>
References: <20100428223321.GO8749@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100428223321.GO8749-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Arthur,

On 15:33 Wed 28 Apr     , Arthur Kepner wrote:
> 
> One of our customers recently merged some new systems into a
> large, existing cluster. They requested a mechanism to prevent
> opensm from sweeping while the new equipment was being added to
> the IB fabric, and then resume sweeping once they felt confident
> that the newly added (sub)fabric was correctly cabled, and fully
> functional. They used the following patch.

You want to disable sweep. So why do you need "toggling"?

Run OpenSM with sweep disabled, config parameters:

sweep_interval 0
sweep_on_trap FALSE

And when you are comfortable with doing resweep just rerun OpenSM
without such options (or may be sending SIGHUP).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
