From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] selinux: Allocate and free infiniband security hooks
Date: Fri, 1 Jul 2016 14:54:11 -0400
Message-ID: <CAGH-KgtKkCvynjRJKAvVxdQdCj727bH0eaHBLj3RJY2=GW=D9g@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-5-git-send-email-danielj@mellanox.com> <CAGH-KgvtN8T7e5bKq0jJZvSzrGfFwA2VpmPf5gJuqdLZi6odEw@mail.gmail.com>
 <6662b3b0-6897-8775-dc30-2757387428e4@schaufler-ca.com> <AM4PR0501MB2257ADAB527392547179F779C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB2257ADAB527392547179F779C4240-dp/nxUn679hpbkYrVjfdjcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 5:48 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 6/30/2016 4:06 PM, Casey Schaufler wrote:
>> On 6/30/2016 1:42 PM, Paul Moore wrote:

>>>>  };
>>>>
>>>>  /**
>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>> index 3f6780b..e522acb 100644
>>>> --- a/include/rdma/ib_verbs.h
>>>> +++ b/include/rdma/ib_verbs.h
>>>> @@ -1454,6 +1454,7 @@ struct ib_qp {
>>>>         void                   *qp_context;
>>>>         u32                     qp_num;
>>>>         enum ib_qp_type         qp_type;
>>>> +       struct ib_qp_security  *qp_sec;
>>> See my earlier question/comment about just using a void pointer here.
>>
>> I think that this is in response to my comments to the
>> effect that I would like to see the LSM infrastructure
>> using the inode like (inode->i_security) to the xfrm
>> (void *) approach. I haven't been looking at the IB patches
>> too carefully to date. It's possible I have not been clear.
>
> My understanding at the time was that by using something other than a void * different security modules could maintain their own opaque blobs with in and keep the same prototype for the hook.  It's possible I misunderstood you, but it made sense to me.  I don't know of any plans for other security modules to support Infiniband, but this leaves the door open.

All of what you describe above can still happen with a void pointer;
in some ways it is even easier with a void pointer.

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
