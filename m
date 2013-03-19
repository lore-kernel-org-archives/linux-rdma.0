From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [RFC ib_srp-backport] ib_srp: bind fast IO failing to QP timeout
Date: Tue, 19 Mar 2013 12:38:03 +0100
Message-ID: <51484E1B.5010407@profitbricks.com>
References: <51483B19.1070201@profitbricks.com> <51484A5F.6040601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51484A5F.6040601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19.03.2013 12:22, Or Gerlitz wrote:
> On 19/03/2013 12:16, Sebastian Riemer wrote:
>> Hi Bart,
>>
>> now I've got my priority on SRP again.
> 
> Hi Sebastian,
> 
> Are these patches targeted to upstream or backports to some OS/kernel?
> if the former, can you please
> send them inline so we can have proper review?
> 
> Or.

Hi Or,

the patches are targeted to the stuff Bart is doing on GitHub.
https://github.com/bvanassche/ib_srp-backport

If I've seen that right, fast IO failing hasn't been accepted to the
mainline, yet.

So I didn't want to spam you all with multiple mails of patches which
don't apply to upstream.
I want to introduce my idea in the first place. The patches are not a
final solution to the problem. They should only show what I'm trying to
do here.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
