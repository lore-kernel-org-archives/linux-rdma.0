From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] buildlib: add script to dump ABI
Date: Wed, 15 Nov 2017 12:36:44 -0700
Message-ID: <20171115193644.GS25894@ziepe.ca>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <8bcdf747-5613-8990-5742-8a9b6e552ac9@morey-chaisemartin.com>
 <20171115055632.GR18825@mtr-leonro.local>
 <b36cd702-5d8e-c116-3306-39e1a1b8aaf5@suse.de>
 <20171115173719.GC18825@mtr-leonro.local>
 <9f40619b-bd97-ad6f-494b-c493dd3c3c21@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9f40619b-bd97-ad6f-494b-c493dd3c3c21-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 06:52:49PM +0100, Nicolas Morey-Chaisemartin wrote:

> Does that changes something ? As long as the specific build-abi build generates the .so, it should be sufficient to check the ABI.
> Wether someone build with static options or not.
> Unless there are other static libs I'm missing.

Correct, there is no need to check the static library - and it will be
much harder to extract the public ABI from the private internal ABI
when working with a static library.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
