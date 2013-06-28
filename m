From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 02/15] IB/srp: Fix race between srp_queuecommand()
 and srp_claim_req()
Date: Fri, 28 Jun 2013 17:08:48 +0200
Message-ID: <51CDA700.7050009@profitbricks.com>
References: <51CD856A.3010102@acm.org> <51CD8604.5010801@acm.org> <51CDA0CD.6060504@profitbricks.com> <51CDA2E5.2010704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CDA2E5.2010704-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28.06.2013 16:51, Bart Van Assche wrote:
>> Nice, that's much less re-acquiring of the target lock in error case in
>> srp_queuecommand().
>> But if we have to change that many locations for srp_put_tx_iu() anyway,
>> wouldn't it make sense to rename it into __srp_put_tx_iu() as well?
>>
>> Then we can also put a little description to it and it looks familiar
>> compared to __srp_get_tx_iu().
>>
>> The description could look like follows:
>> /*
>>   * Return an IU and possible credit to the free pool
>>   *
>>   * Must be called with target->lock held to protect free_tx.
>>   */
>>
>> I'm not sure if we still need that lockdep_assert_held() then. There is
>> no other location with lock debugging in ib_srp.
> 
> Hello Sebastian,
> 
> I don't have a strong opinion about either of these two topics.
> 
> If a function like __srp_get_tx_iu() would be introduced that would
> allow to drop only two spin_lock/spin_unlock call pairs. So introducing
> that function would probably add more lines of code than adding the
> spin_lock/spin_unlock pairs. Hence my choice not to introduce
> __srp_get_tx_iu().
> 
> Regarding the lockdep_assert_held() statement: the reason I introduced
> it instead of adding a comment above the function telling which locking
> is required is because a lockdep_assert_held() statement is verified at
> runtime on a system with a kernel in which lockdep support has been
> enabled.

Hi Bart,

I just meant a rename into "__srp_put_tx_iu()" to show that locking is
required and not introducing a further wrapper function.

The other function of that kind "__srp_get_tx_iu()" also doesn't have a
wrapper function "srp_get_tx_iu()".

For me it doesn't make much difference how it is marked that locking is
required. I just wanted to point out that this method is new to ib_srp.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
