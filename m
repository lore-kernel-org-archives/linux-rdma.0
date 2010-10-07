From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: Re: Where is the latest GIT for opensm?
Date: Thu, 7 Oct 2010 08:47:18 -0700
Message-ID: <4CADEB86.10408@nasa.gov>
References: <20101007023314.GA21206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007023314.GA21206-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 Hi Jason.

On 10/06/10 19:33, Jason Gunthorpe wrote:
> Hey Sasha,
>
> Can you tell me where the latest git repository for OpenSM is these
> days? There doesn't seem to be anything recent on the OFA server,
> ie
>
> git://git.openfabrics.org/~sashak/management.git
>
> Is quite old.

Yes. The problem is that most of the developers have not yet moved to
the new server. For your example, I had to do:

git clone git://69.55.239.13/~sashak/management.git

to get the up to date repo. on the old server.

It would be great if developers could move their git repo's to the new
server so OFA can stop using (and paying) for the old server. Vlad sent
out a note about this earlier.

Thanks.

-jeff
> Thanks,
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
