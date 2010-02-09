From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Patch series from Dec 2009 which needs reviewing/applying
Date: Tue, 09 Feb 2010 09:22:11 -0800
Message-ID: <adamxziiat8.fsf@roland-alpha.cisco.com>
References: <201002041059.09368.jackm@dev.mellanox.co.il>
	<adapr4fwt68.fsf@roland-alpha.cisco.com>
	<201002091920.41978.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002091920.41978.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Tue, 9 Feb 2010 19:20:41 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > =C2=A0> [PATCH 0/2] fix SRQ WQE buffer initialization in liblmx4 a=
nd in mlx4_ib
 > > =C2=A0> http://www.spinics.net/lists/linux-rdma/msg01911.html
 > >=20
 > > This isn't a patch AFAICT.
 > >=20
 > You are right, it isn't.  Generally, when I submit a patch series, I=
 do
 > a [PATCH 0/??] to contain overall explanatory notes.
 > If you would rather I call the submission something else, that is no=
 problem.
 >=20
 > What would you like to see in the subject line for an e-mail which i=
ntroduces a patch series?

The series is fine.  I was just saying that the first email you pointed
to had nothing to merge.  As far as I know, the kernel mlx4_ib patch wa=
s
already merged, and I merged the libmlx4 patch yesterday, so the SRQ
initialization fixes are in place, right?
--=20
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
=46or corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
