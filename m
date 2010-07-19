From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes	driver
Date: Mon, 19 Jul 2010 16:44:06 +0300
Message-ID: <4C4456A6.8070206@Voltaire.com>
References: <20100705135438.26042.55865.stgit@gkslx010.igk.intel.com>	<4C32EE45.9030906@Voltaire.com>	<BE2BFE91933D1B4089447C64486040801EBB3C34@irsmsx503.ger.corp.intel.com>	<4C342288.4070803@voltaire.com> <4C433148.1090503@Voltaire.com> <BE2BFE91933D1B4089447C64486040804DF682AC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040804DF682AC-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Walukiewicz, Miroslaw wrote:
> I agree with you that it is possible to fix the post_send path in OFED.
> Let me think a few days yet.

Hi Mirek,

okay. 

Just one comment, the way I see it, ofed is very much not something that has "post_send path", its a temporary, ad-hock, very far from being well organized, and actually much worse then you may think (try the archives for "shovel in unreviewed junk" or "pile of shit") collection of bits which pretend to be a distribution of the Linux IB stack 

The credit or discredit and or questions, patches, bugs && flames for this or that element of the IB stack, should all go to the maintainer/s. Specifically of libibverbs, ib_uverbs etc (happen to be CC-ed here...)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
