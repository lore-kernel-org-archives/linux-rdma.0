From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 16:14:39 -0700
Message-ID: <BANLkTikLeWHYLKrX8O=syt-Q+b6LP2PCtw@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
 <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com> <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
 <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com> <055701cc1b29$c8fcc6c0$5af65440$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <055701cc1b29$c8fcc6c0$5af65440$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2011 at 3:19 PM, Bob Pearson
<rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> With lash+mesh redsky required 6-7 VLs to wire up without deadlocks. I think
> that Jim's version uses 8 SLs but only 2VLs to work.
> If someone was using a torus and also wanted to support QOS and also wanted
> to separate multicast and management on a separate VL to be absolutely sure
> that there is no possibility of a deadlock you might end up with #QOS * 2 +
> 1 which would be 5 using the current algorithm.

But again you don't need all those VLs on the HCAs' links, do you?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
