From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/12] selinux: Implement Infiniband PKey "Access" access vector
Date: Fri, 1 Jul 2016 16:42:47 -0400
Message-ID: <CAGH-KgsE2tPOpqb6tzWd02avj8hSsDnxw2p2rD4xy4RdTdvuYw@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-6-git-send-email-danielj@mellanox.com> <CAGH-KgtNiMrLVz_fMG22WcpAL3EQq9ike=EYHfxbBa4Sg2-R8A@mail.gmail.com>
 <DB6PR0501MB2261BC286E974CFE76B1E901C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
 <CAGH-KgvS7jvd4yiO-BGyqCbuZEwbXbjE61s2B7G6r=rOZse7iw@mail.gmail.com>
 <DB6PR0501MB22614C80007D7408544B4B30C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
 <CAGH-KguvznwFOhYVhPKdu0t8_z=Q_eZ5Njss=ECWquagPhkc2Q@mail.gmail.com> <DB6PR0501MB2261C903AB4CE9644604B9E8C4250@DB6PR0501MB2261.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0501MB2261C903AB4CE9644604B9E8C4250-wTfl6qNNZ1NK98U9gK7MJ8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 1, 2016 at 3:57 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 7/1/2016 2:26 PM, Paul Moore wrote:
>> On Fri, Jul 1, 2016 at 3:16 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 7/1/2016 1:59 PM, Paul Moore wrote:
>>>> On Fri, Jul 1, 2016 at 2:21 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> On 7/1/2016 11:29 AM, Paul Moore wrote:
>>>>>> I wondered about this earlier in the patchset when we were discussing
>>>>>> the policy format, and I'm still wondering; perhaps you can help me
>>>>>> understand IB a bit better ...
>>>>>>
>>>>>> From what I gather, the partition key is the IB security boundary, not
>>>>>> the subnet, is that true?  If so, why are we including the subnet with
>>>>>> the partition key value/label?  I understand the low/high pkey range
>>>>>> as a way of simplifying the policy, but I don't quite understand the
>>>>>> point of tying the subnet to the partition key label.  Would you ever
>>>>>> want to have multiple labels for a single partition key, or should it
>>>>>> be a single label for the partition key regardless of the subnet?
>>>>>>
>>>>> Each subnet can have a different partition configuration and a node can be on multiple subnets.  By specifying the subnet prefix along with the pkey value the user has flexibility to have different policy for different subnets, instead of a global PKey space that would require coordinating the partition configuration across all subnets.
>>>> Perhaps a better explanation of partitions and subnets are in order,
>>>> especially for those of like me who are new to IB.
>>>>
>>> A subnet is a set of ports managed by a common subnet manager, which sets up the partition configuration.
>> So there can be multiple partitions inside a subnet and not multiple
>> subnets inside a partition?
>
> Yes, a each subnet can have many partitions.  The partitions are contained within that subnet, a different subnet can have a partition that uses same PKey value, but that's a different partition.  So if we have 2 subnets, fe80:: and fe81:: they can each have a partition that uses PKey X but it doesn't mean nodes with access to that partition on 0xfe80 can reach nodes on 0xfe81 on that partition.

Thanks, that clears things up.  Originally I thought it was the other
way around which we causing a lot of confusion on my part.

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
