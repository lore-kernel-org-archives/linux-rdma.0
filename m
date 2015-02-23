From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Mon, 23 Feb 2015 13:54:14 -0500
Message-ID: <54EB7756.7070407@dev.mellanox.co.il>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-15-git-send-email-ira.weiny@intel.com> <54D52589.8020305@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com> <54DCB1E9.7010309@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC29020-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/17/2015 4:25 PM, Weiny, Ira wrote:
>>>>>
>>>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h in=
dex
>>>>> 3ab4033..2614233 100644
>>>>> --- a/include/rdma/ib_verbs.h
>>>>> +++ b/include/rdma/ib_verbs.h
>>>>> @@ -128,6 +128,10 @@ enum ib_device_cap_flags {
>>>>>  	IB_DEVICE_ON_DEMAND_PAGING	=3D (1<<31),
>>>>>  };
>>>>>
>>>>> +enum ib_device_cap_flags2 {
>>>>> +	IB_DEVICE_OPA_MAD_SUPPORT	=3D 1
>>>>> +};
>>>>> +
>>>>>  enum ib_signature_prot_cap {
>>>>>  	IB_PROT_T10DIF_TYPE_1 =3D 1,
>>>>>  	IB_PROT_T10DIF_TYPE_2 =3D 1 << 1,
>>>>> @@ -210,6 +214,7 @@ struct ib_device_attr {
>>>>>  	int			sig_prot_cap;
>>>>>  	int			sig_guard_cap;
>>>>>  	struct ib_odp_caps	odp_caps;
>>>>> +	u64			device_cap_flags2;
>>>>>  	u32			max_mad_size;
>>>>>  };
>>>>>
>>>>
>>>> Why is OPA support determined via a device capability flag ? What =
are
>>>> the tradeoffs for doing it this way versus the other choices that
>>>> have been used in the past for other RDMA technologies like RoCE, =
iWARP,
>> usNIC, ... ?
>>>
>>> None of those technologies use the MAD stack for Subnet Management.
>> Other MAD support is very limited (ie IB compatible PMA queries on t=
he local
>> port only).
>>>
>>> Do you have a suggestion for alternatives?
>>
>> The desire to leverage the IB MAD infrastructure for OPA is understo=
od but the
>> current approach represents OPA as a device capability which does no=
t seem
>> appropriate because OPA is clearly a different type of RDMA technolo=
gy than
>> IB.
>>
>=20
> While it is a different type of technology, standard verbs[*] remains=
 100% compatible.  Unlike other verbs technologies user space software =
does not need any knowledge that the underlying device is not IB.  For =
example, PR (and SA) queries, CM, rdmacm, and verbs calls themselves ar=
e all 100% IB compatible.

Even if OPA is 100% standard verbs compatible which it does not appear
to be, that does not make OPA an extra capability of an IBA device.
While it is a primary goal of the RDMA stack to have a common verbs API
for various RDMA interconnects, each one is properly represented to
allow it=92s unique characteristics to be exposed.

> Therefore, to address your initial question regarding tradeoffs I bel=
ieve this method is the least invasive to the code as well as removing =
any potential performance penalties to core verbs.
>=20
> Ira
>=20
> [*] We don't support some of the extensions particularly those which =
have been most recently introduced.  And we would like to make our own =
extensions in the form of higher MTU availability, but the patch is not=
 yet ready to be submitted upstream.

There appear to be a number of things that are not exposed by the
current patch set which will be needed in subsequent patches. It would
be better to see the complete picture so it can be reviewed as a whole.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
