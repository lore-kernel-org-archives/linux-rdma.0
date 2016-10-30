From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Post userspace patches here, or pull requests to github?
Date: Sun, 30 Oct 2016 19:11:38 +0000
Message-ID: <5B1D20F7-4C15-4ABF-BA1C-6BD2989451EA@cisco.com>
References: <2DD5ED3D-7F86-4AAF-863B-F2ED30B9A798@cisco.com>
 <20161030180356.GA25939@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161030180356.GA25939-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <4A11F8731B3D15458F900BC7305CA3CC-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Oct 30, 2016, at 2:03 PM, Jason Gunthorpe <jgunthorpe@obsidianresearch.c=
om> wrote:
>=20
> We have been asking for posting here as well..

Ok.

> Are you still using usnic with verbs? I thought you moved everything
> to libfabric? Should the usnic verbs provider be added to rdma-core?

The usnic_verbs driver is upstream in the kernel, and ib core returns that =
long string; that's the primary reason for this fix.

I don't think there's a need to have a usnic verbs provider in rdma-core at=
 this time.

--=20
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing=
_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
