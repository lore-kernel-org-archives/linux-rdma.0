From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Tue, 31 May 2011 01:07:22 +0300
Message-ID: <BANLkTinK+YHUyF4ThHQAwFeZ4FNswpY-tw@mail.gmail.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
	<BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
	<BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
	<BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
	<055701cc1b29$c8fcc6c0$5af65440$@systemfabricworks.com>
	<BANLkTikLeWHYLKrX8O=syt-Q+b6LP2PCtw@mail.gmail.com>
	<4DDDF0B1.6090305@mellanox.com>
	<17495_1306419903_p4QEMqSb018281_4DDE6291.1090809@sandia.gov>
	<4DDE63F9.8060502@sandia.gov>
	<BANLkTimGioibPTUYV046ObOPhHntHxx72w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimGioibPTUYV046ObOPhHntHxx72w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org> wrote:
>> no good reason to insist that the VL usage is the same for both
>> interswitch links, and switch-CA links. Do I need to change this?

> I don't think changing this is a high priority, since it's a pretty small
> slice of the world, and QoS on the edge links probably is important
> to an even smaller slice, but IMHO it would be better to give QoS to
> HCAs that only support 4 VLs by using a different SL2VL table for links to CAs.

Jim,

AFAIK, the way opensm applies an SL-to-VL mapping specification (e.g
dictated by the admin or maybe your routing engine) on a specific link
is by modulation on the number of active VLs for that link - e.g say
the ID mapping was required and there are two VLs for that link, so
we'll have SL-to-VL of 0->0 1->1 2->0 3->1 and so on. So in that
respect, I wasn't sure what's the change here for you.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
