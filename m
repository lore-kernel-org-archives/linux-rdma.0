From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 6/8] verbs: Fill in the libibverbs.map file
Date: Mon, 11 Dec 2017 08:48:11 -0700
Message-ID: <20171211154811.GA6162@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
 <20171205231721.19410-7-jgg@ziepe.ca>
 <38cbce8e-d177-b4eb-efec-c54951b1cb29@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <38cbce8e-d177-b4eb-efec-c54951b1cb29-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 10, 2017 at 07:01:52PM +0200, Yishai Hadas wrote:
> On 12/6/2017 1:17 AM, Jason Gunthorpe wrote:
> >From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >Several of the 'latest' verbs are missing from the map file.
> 
> Which 'latest' verbs are you referring to ? quite hard to follow post the
> sort.

Pretty much all the ones listed as '+' in - 'latest' means they are
using LATEST_SYMVER_FUNC

> >The linker does the right thing anyhow since they are tagged with the
> >.symver assembler directive, but let us list them anyhow so that the
> >map file is a complete list of symbols.
> 
> If the linker does the work why do we really need to maintain it now and in
> the future ?

Technicaly all symbols should be in the map file. I would view the
linker exposing symbols not in the map file as some weird behavior we
shouldn't rely on.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
