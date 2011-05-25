From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 17:19:15 -0500
Message-ID: <055701cc1b29$c8fcc6c0$5af65440$@systemfabricworks.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com> <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com> <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com> <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

With lash+mesh redsky required 6-7 VLs to wire up without deadlocks. I think
that Jim's version uses 8 SLs but only 2VLs to work.
If someone was using a torus and also wanted to support QOS and also wanted
to separate multicast and management on a separate VL to be absolutely sure
that there is no possibility of a deadlock you might end up with #QOS * 2 +
1 which would be 5 using the current algorithm.

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Wednesday, May 25, 2011 4:28 PM
To: Or Gerlitz
Cc: Or Gerlitz; linux-rdma; Vladimir Sokolovsky
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports

On Wed, May 25, 2011 at 2:05 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Does anyone really care about max VL cap with 2K MTU?
>
> I'm not with you... can you elaborate a little further here? the 
> current HW generation support four VLs with 4k mtu, newer HW might 
> support more.

I mean is there anyone who really uses >4 VLs?  Presumably the HW designers
didn't think so, because they limited HW to 4 VLs with 4K MTU.

At least can we make this a runtime thing?  If we're able to set a port as
IB vs ethernet then # of VLs seems like it should be doable too.

And 4K MTU should probably be the default, since almost all users want 4K
MTU vs. caring about VLs.  (Probably 99% of IB users never set SL of
anything)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
