From: Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH 04/12] selinux: Allocate and free infiniband security hooks
Date: Fri, 1 Jul 2016 18:15:07 -0400
Message-ID: <CAGH-KguSnb7mCTEmEMRKn_NgpDtSpgttB877GNCKywg1pJhfzQ@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-5-git-send-email-danielj@mellanox.com> <CAGH-KgvtN8T7e5bKq0jJZvSzrGfFwA2VpmPf5gJuqdLZi6odEw@mail.gmail.com>
 <6662b3b0-6897-8775-dc30-2757387428e4@schaufler-ca.com> <AM4PR0501MB2257ADAB527392547179F779C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
 <CAGH-KgtKkCvynjRJKAvVxdQdCj727bH0eaHBLj3RJY2=GW=D9g@mail.gmail.com>
 <DB6PR0501MB2261A2F4D095F672A814388DC4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
 <CAGH-Kgtz7pXNJrcc-OOwGyefzm5MpsVqjyZ+UaR9pefoNMWiwg@mail.gmail.com>
 <4bdbd27c-ff4a-db87-a550-cd187cbc07c6@schaufler-ca.com> <DB6PR0501MB226138FF74D031F6BD1C48C6C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <DB6PR0501MB226138FF74D031F6BD1C48C6C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Daniel Jurgens <danielj@mellanox.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "paul@paul-moore.com" <paul@paul-moore.com>, "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>, "eparis@parisplace.org" <eparis@parisplace.org>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 1, 2016 at 4:46 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
> On 7/1/2016 3:13 PM, Casey Schaufler wrote:
>> On 7/1/2016 12:17 PM, Paul Moore wrote:
>>> On Fri, Jul 1, 2016 at 2:59 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
>>>> On 7/1/2016 1:54 PM, Paul Moore wrote:
>>>>> On Thu, Jun 30, 2016 at 5:48 PM, Daniel Jurgens <danielj@mellanox.com> wrote:
>>>>>> On 6/30/2016 4:06 PM, Casey Schaufler wrote:
>>>>>>> On 6/30/2016 1:42 PM, Paul Moore wrote:
>>>>>>>>>  };
>>>>>>>>>
>>>>>>>>>  /**
>>>>>>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>>>>>>>> index 3f6780b..e522acb 100644
>>>>>>>>> --- a/include/rdma/ib_verbs.h
>>>>>>>>> +++ b/include/rdma/ib_verbs.h
>>>>>>>>> @@ -1454,6 +1454,7 @@ struct ib_qp {
>>>>>>>>>         void                   *qp_context;
>>>>>>>>>         u32                     qp_num;
>>>>>>>>>         enum ib_qp_type         qp_type;
>>>>>>>>> +       struct ib_qp_security  *qp_sec;
>>>>>>>> See my earlier question/comment about just using a void pointer here.
>>>>>>> I think that this is in response to my comments to the
>>>>>>> effect that I would like to see the LSM infrastructure
>>>>>>> using the inode like (inode->i_security) to the xfrm
>>>>>>> (void *) approach. I haven't been looking at the IB patches
>>>>>>> too carefully to date. It's possible I have not been clear.
>>>>>> My understanding at the time was that by using something other than a void * different security modules could maintain their own opaque blobs with in and keep the same prototype for the hook.  It's possible I misunderstood you, but it made sense to me.  I don't know of any plans for other security modules to support Infiniband, but this leaves the door open.
>>>>> All of what you describe above can still happen with a void pointer;
>>>>> in some ways it is even easier with a void pointer.
>>>> If multiple security modules register an alloc_security hook for example, how would you coordinate between them to allocate the memory?
>>> You worry about that in the LSM framework and hide the details behind
>>> the void pointer.  For example, you create an array/list of LSM
>>> specific blobs and just stash a pointer to the head of the data in the
>>> void pointer.
>> Don't worry about it at this point. Patches pending.
>> If I have to change modules to accommodate the
>> infrastructure I'm not afraid to do so.
>
> So I should revert to void* blobs?  I just want to be clear before making the change.

Yes.

-- 
paul moore
security @ redhat
