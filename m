From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] net/mlx5: E-Switch, Add control for inline mode
Date: Wed, 30 Nov 2016 00:25:54 +0300
Message-ID: <20161129212554.GF28558@mwanda>
References: <20161129105258.GA31063@mwanda>
 <fa981369-2032-eb9e-6307-f3055297e7e6@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fa981369-2032-eb9e-6307-f3055297e7e6-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 29, 2016 at 05:06:55PM +0200, Roi Dayan wrote:
> I really didn't see this. sparse and smatch didn't catch this. I use
> FC24 and gcc 6.2.1 for compilation and it doesn't give me any
> warning.
> Did another check with an old rhel machine with gcc 4.4.6 and I got
> a warning about it there.
> Can you tell me which tool you used?

Some new unreleased Smatch stuff I'm working on.

> 
> This is a false positive because of the first check if vport > 1, we
> actually check prev_mlx5_mode from the second for-loop
> iteration and on the first loop iteration we set a value (in line 952).
> It is used to check if all vports are set with the same inline mode.

Oh crap...  Smatch takes a short cut handling loops (I really need to
fix this but I wrote the orginal code a decade ago).  I misread how the
loops works as well.  Sorry for the noise.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
