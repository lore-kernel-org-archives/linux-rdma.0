From: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Mon, 12 Nov 2012 18:46:05 -0500
Message-ID: <50A18A3D.9070304@ddn.com>
References: <4FC53AAA.3060203@ddn.com> <1338354377.2361.13.camel@obelisk.thedillows.org> <CAJZOPZL0cj6Sb_xs7prV0k8HjWkELD7Y89Bxxp-xXnnGqxvXyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZL0cj6Sb_xs7prV0k8HjWkELD7Y89Bxxp-xXnnGqxvXyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In my experience with ib-srp, I am not sure if there is such a thing as 
link going down for a short time. When the link goes down, no matter how 
short the duration (< 1s), IO fails over, this failover takes very long 
time currently. Or, I would like to know if you can get a ib-srp 
failover time of less than a minute somehow (by tweaking OS or multipath 
settings). I was unable to get it to work even after a pretty exhaustive 
attempt.

Dave, on a separate note, with OFED-1.5.4 and RHEL-6x, I have tried 
setting ib_srp.srp_dev_loss_tmo=5 seconds, it does not seem to help 
failover time.

Karan

On 11/12/2012 06:10 PM, Or Gerlitz wrote:
> On Wed, May 30, 2012 at 7:06 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
>> On Tue, 2012-05-29 at 17:07 -0400, Karandeep Chahal wrote:
>>> Subject: [PATCH] Infiniband srp fast failover patch.
>> This conflicts with Bart's patches to improve failover; it will be much
>> better to use his approach to block the target rather than remove it
>> wholesale -- we could have lost connectivity as a transient and may get
>> it back quickly if someone grabbed the wrong cable, etc.
>>
>> Also, we should only kill the one target on DREQ, and we already have a
>> pointer to it from the CM context -- no need to search.
>>
>> It is a good idea to hook into the event mechanism;
> Dave,
>
> I wonder why this hooking is the correct way to go, if the IB link
> went down for very short time, why should we care, what's missing in
> relying on probes done by HA SW such as multipath and RC timeouts?
>
> Or.
>
>> this is something I've long wanted to incorporate (as Vu did in OFED). I'm looking at
>> getting Bart's series to a point I can merge it, and I'll pull in your
>> ideas -- with credit -- there.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
