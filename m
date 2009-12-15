From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 12:56:19 -0500
Message-ID: <f0e08f230912150956t735c8bf2r41aa3943d8305797@mail.gmail.com>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	 <20091215170317.GV5262@me>
	 <20091215171532.GA8288@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091215171532.GA8288-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2009 at 12:15 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > However, I don't understand the comment "Only set HopLimit if going through a
>> > router"?
>>
>> This is from '#ifdef ROUTER_EXP' days - as far as I could understand
>> HopLimit should be set to IB_HOPLIMIT_MAX for inter-subnet MADs.
>
> If HopLimit is 0 then no GRH is required, if it is non 0 then the user

I think it is:
HopLimit 0 or 1 requires no GRH (GRH is optional in these cases)
and
other than 0 or 1 requires GRH

> of that path needs to apply a GRH. IIRC there are already a few things
> in the kernel that follow this?

Yes, we started down this path. This was all discussed on the list
back prior to SC07 days AFAIR.

-- Hal

> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
