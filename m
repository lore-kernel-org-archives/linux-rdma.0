From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/2] Add MR re-registeration
Date: Thu, 3 Mar 2016 10:45:01 -0500
Message-ID: <56D85BFD.6080701@redhat.com>
References: <1452524718-21575-1-git-send-email-yishaih@mellanox.com>
 <1452524718-21575-3-git-send-email-yishaih@mellanox.com>
 <56D7A1C1.8070306@redhat.com> <56D80B9B.8010703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SADNTH0CRDEPc8X7CAFqCpbP3eJjJod7P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56D80B9B.8010703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SADNTH0CRDEPc8X7CAFqCpbP3eJjJod7P
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/03/2016 05:02 AM, Yishai Hadas wrote:
> On 3/3/2016 4:30 AM, Doug Ledford wrote:
>> On 1/11/2016 10:05 AM, Yishai Hadas wrote:
>>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> Memory re-registeration is a feature that enables one to change
>>> the attributes of a memory region, including PD, translation
>>> (address and length) and access flags.
>>>
>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>   include/infiniband/driver.h   |  5 ++++
>>>   include/infiniband/kern-abi.h | 20 ++++++++++++++
>>>   include/infiniband/verbs.h    |  9 ++++++-
>>>   man/ibv_rereg_mr.3            | 62
>>> +++++++++++++++++++++++++++++++++++++++++++
>>>   src/cmd.c                     | 29 ++++++++++++++++++++
>>>   src/libibverbs.map            |  1 +
>>>   src/verbs.c                   | 56
>>> ++++++++++++++++++++++++++++++++++++++
>>>   7 files changed, 181 insertions(+), 1 deletion(-)
>>>   create mode 100644 man/ibv_rereg_mr.3
>>>
>>> diff --git a/include/infiniband/driver.h b/include/infiniband/driver.=
h
>>> index 8227df0..5226784 100644
>>> --- a/include/infiniband/driver.h
>>> +++ b/include/infiniband/driver.h
>>> @@ -138,6 +138,11 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void
>>> *addr, size_t length,
>>>              struct ibv_mr *mr, struct ibv_reg_mr *cmd,
>>>              size_t cmd_size,
>>>              struct ibv_reg_mr_resp *resp, size_t resp_size);
>>> +int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
>>> +             size_t length, uint64_t hca_va, int access,
>>> +             struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
>>> +             size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
>>> +             size_t resp_sz);
>>>   int ibv_cmd_dereg_mr(struct ibv_mr *mr);
>>>   int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
>>>                 struct ibv_comp_channel *channel,
>>> diff --git a/include/infiniband/kern-abi.h
>>> b/include/infiniband/kern-abi.h
>>> index 800c5ab..8bab69f 100644
>>> --- a/include/infiniband/kern-abi.h
>>> +++ b/include/infiniband/kern-abi.h
>>> @@ -362,6 +362,26 @@ struct ibv_reg_mr_resp {
>>>       __u32 rkey;
>>>   };
>>>
>>> +struct ibv_rereg_mr {
>>> +    __u32 command;
>>> +    __u16 in_words;
>>> +    __u16 out_words;
>>> +    __u64 response;
>>> +    __u32 mr_handle;
>>> +    __u32 flags;
>>> +    __u64 start;
>>> +    __u64 length;
>>> +    __u64 hca_va;
>>> +    __u32 pd_handle;
>>> +    __u32 access_flags;
>>> +    __u64 driver_data[0];
>>> +};
>>> +
>>> +struct ibv_rereg_mr_resp {
>>> +    __u32 lkey;
>>> +    __u32 rkey;
>>> +};
>>> +
>>>   struct ibv_dereg_mr {
>>>       __u32 command;
>>>       __u16 in_words;
>>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>>> index 48e868c..69e4e29 100644
>>> --- a/include/infiniband/verbs.h
>>> +++ b/include/infiniband/verbs.h
>>> @@ -411,7 +411,8 @@ enum ibv_rereg_mr_flags {
>>>       IBV_REREG_MR_CHANGE_TRANSLATION    =3D (1 << 0),
>>>       IBV_REREG_MR_CHANGE_PD        =3D (1 << 1),
>>>       IBV_REREG_MR_CHANGE_ACCESS    =3D (1 << 2),
>>> -    IBV_REREG_MR_KEEP_VALID        =3D (1 << 3)
>>> +    IBV_REREG_MR_KEEP_VALID        =3D (1 << 3),
>>> +    IBV_REREG_MR_FLAGS_SUPPORTED    =3D ((IBV_REREG_MR_KEEP_VALID <<=

>>> 1) - 1)
>>>   };
>>>
>>>   struct ibv_mr {
>>> @@ -1228,6 +1229,12 @@ struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd,
>>> void *addr,
>>>                 size_t length, int access);
>>>
>>>   /**
>>> + * ibv_rereg_mr - Re-Register a memory region
>>> + */
>>> +int ibv_rereg_mr(struct ibv_mr *mr, int flags,
>>> +         struct ibv_pd *pd, void *addr,
>>> +         size_t length, int access);
>>> +/**
>>>    * ibv_dereg_mr - Deregister a memory region
>>>    */
>>>   int ibv_dereg_mr(struct ibv_mr *mr);
>>> diff --git a/man/ibv_rereg_mr.3 b/man/ibv_rereg_mr.3
>>> new file mode 100644
>>> index 0000000..ccb03cf
>>> --- /dev/null
>>> +++ b/man/ibv_rereg_mr.3
>>> @@ -0,0 +1,62 @@
>>> +.\" -*- nroff -*-
>>> +.\"
>>> +.TH IBV_REREG_MR 3 2014-08-27 libibverbs "Libibverbs Programmer's
>>> Manual"
>>> +.SH "NAME"
>>> +ibv_rereg_mr \- re-register a memory region (MR)
>>> +.SH "SYNOPSIS"
>>> +.nf
>>> +.B #include <infiniband/verbs.h>
>>> +.sp
>>> +.BI "int ibv_rereg_mr(struct ibv_mr " "*mr" ", int " " flags" ,
>>> +.BI "                 struct ibv_pd * " "pd" ", void " " *addr",
>>> +.BI "                 size_t " " length" ", int " " access");
>>> +.fi
>>> +.fi
>>> +.SH "DESCRIPTION"
>>> +.B ibv_rereg_mr()
>>> +Modifies the attributes of an existing memory region (MR)
>>> +.I mr\fR.
>>> +Conceptually, this call performs the functions deregister memory reg=
ion
>>> +followed by register memory region.  Where possible,
>>> +resources are reused instead of deallocated and reallocated.
>>> +.PP
>>> +.I flags\fR
>>> +is a bit-mask used to indicate which of the following properties of
>>> the memory region are being modified. Flags should be a combination
>>> (bit field) of:
>>> +.PP
>>> +.TP
>>> +.B IBV_REREG_MR_CHANGE_TRANSLATION \fR Change translation (location
>>> and length)
>>> +.TP
>>> +.B IBV_REREG_MR_CHANGE_PD \fR Change protection domain
>>> +.TP
>>> +.B IBV_REREG_MR_CHANGE_ACCESS \fR Change access flags
>>> +.PP
>>> +When
>>> +.B IBV_REREG_MR_CHANGE_PD
>>> +is used,
>>> +.I pd\fR
>>> +represents the new PD this MR should be registered to.
>>> +.br
>>> +When
>>> +.B IBV_REREG_MR_CHANGE_TRANSLATION
>>> +is used,
>>> +.I addr\fR.
>>> +represents the virtual address (user-space pointer) of the new MR,
>>> while
>>> +.I length\fR
>>> +represents its length.
>>> +.PP
>>> +The access and other flags are represented in the field
>>> +.I access\fR.
>>> +This field describes the desired memory protection attributes; it is=

>>> either 0 or the bitwise OR of one or more of ibv_access_flags.
>>> +.TP
>>> +.SH "RETURN VALUE"
>>> +.B ibv_rereg_mr()
>>> +returns 0 on success, or the value of errno on failure (which
>>> indicates the failure reason).
>>> +.SH "NOTES"
>>> +If the memory re-registration call failed, the MR shouldn't be used.=

>>> +Even on a failure, the user still needs to call ibv_dereg_mr on this=

>>> MR.
>>> +.SH "SEE ALSO"
>>> +.BR ibv_reg_mr (3),
>>> +.BR ibv_dereg_mr (3),
>>> +.SH "AUTHORS"
>>> +.TP
>>> +Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> diff --git a/src/cmd.c b/src/cmd.c
>>> index e1914e9..e5a32bc 100644
>>> --- a/src/cmd.c
>>> +++ b/src/cmd.c
>>> @@ -334,6 +334,35 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void
>>> *addr, size_t length,
>>>       return 0;
>>>   }
>>>
>>> +int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
>>> +             size_t length, uint64_t hca_va, int access,
>>> +             struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
>>> +             size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
>>> +             size_t resp_sz)
>>> +{
>>> +    IBV_INIT_CMD_RESP(cmd, cmd_sz, REREG_MR, resp, resp_sz);
>>> +
>>> +    cmd->mr_handle      =3D mr->handle;
>>> +    cmd->flags      =3D flags;
>>> +    cmd->start      =3D (uintptr_t)addr;
>>> +    cmd->length      =3D length;
>>> +    cmd->hca_va      =3D hca_va;
>>> +    cmd->pd_handle      =3D (flags & IBV_REREG_MR_CHANGE_PD) ?
>>> pd->handle : 0;
>>> +    cmd->access_flags =3D access;
>>> +
>>> +    if (write(mr->context->cmd_fd, cmd, cmd_sz) !=3D cmd_sz)
>>> +        return errno;
>>> +
>>> +    (void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_sz);
>>> +
>>> +    mr->lkey    =3D resp->lkey;
>>> +    mr->rkey    =3D resp->rkey;
>>> +    if (flags & IBV_REREG_MR_CHANGE_PD)
>>> +        mr->context =3D pd->context;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   int ibv_cmd_dereg_mr(struct ibv_mr *mr)
>>>   {
>>>       struct ibv_dereg_mr cmd;
>>> diff --git a/src/libibverbs.map b/src/libibverbs.map
>>> index 3b40a0f..cbccca7 100644
>>> --- a/src/libibverbs.map
>>> +++ b/src/libibverbs.map
>>> @@ -112,5 +112,6 @@ IBVERBS_1.1 {
>>>           ibv_cmd_create_srq_ex;
>>>           ibv_cmd_create_qp_ex;
>>>           ibv_cmd_open_qp;
>>> +        ibv_cmd_rereg_mr;
>>>
>>>   } IBVERBS_1.0;
>>> diff --git a/src/verbs.c b/src/verbs.c
>>> index ada3515..5938ba0 100644
>>> --- a/src/verbs.c
>>> +++ b/src/verbs.c
>>> @@ -228,6 +228,62 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd,
>>> void *addr,
>>>   }
>>>   default_symver(__ibv_reg_mr, ibv_reg_mr);
>>>
>>> +int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
>>> +           struct ibv_pd *pd, void *addr,
>>> +           size_t length, int access)
>>> +{
>>> +    int dofork_onfail =3D 0;
>>> +    int err;
>>> +    void *old_addr;
>>> +    size_t old_len;
>>> +
>>> +    if (flags & ~IBV_REREG_MR_FLAGS_SUPPORTED) {
>>> +        errno =3D EINVAL;
>>> +        return errno;
>>> +    }
>>> +
>>> +    if ((flags & IBV_REREG_MR_CHANGE_TRANSLATION) &&
>>> +        (!length || !addr)) {
>>> +        errno =3D EINVAL;
>>> +        return errno;
>>> +    }
>>> +
>>> +    if (access && !(flags & IBV_REREG_MR_CHANGE_ACCESS)) {
>>> +        errno =3D EINVAL;
>>> +        return errno;
>>> +    }
>>> +
>>> +    if (!mr->context->ops.rereg_mr) {
>>> +        errno =3D ENOSYS;
>>> +        return errno;
>>> +    }
>>> +
>>> +    if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
>>> +        err =3D ibv_dontfork_range(addr, length);
>>> +        if (err)
>>> +            return err;
>>> +        dofork_onfail =3D 1;
>>> +    }
>>> +
>>> +    old_addr =3D mr->addr;
>>> +    old_len =3D mr->length;
>>> +    err =3D mr->context->ops.rereg_mr(mr, flags, pd, addr, length,
>>> access);
>>> +    if (!err) {
>>> +        if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
>>> +            ibv_dofork_range(old_addr, old_len);
>>> +            mr->addr    =3D addr;
>>> +            mr->length  =3D length;
>>> +        }
>>> +        if (flags & IBV_REREG_MR_CHANGE_PD)
>>> +            mr->pd =3D pd;
>>> +    } else if (dofork_onfail) {
>>> +        ibv_dofork_range(addr, length);
>>
>> Although extremely unlikely, if the ibv_dofork_range fails, which it c=
an
>> for temporary resource issues or the like, then this function will lea=
ve
>> things in an incorrect state and return success to the caller.  It
>> probably needs the return values enumerated in the man page along with=

>> which ones leave the original memory range intact and which ones leave=

>> things in an unknown state where the user would be well advised to
>> remove and recreate the existing memory region.
>=20
> At that step the user will get the driver's error as rereg_mr has
> failed. Talking about few lines above where rereg_mr has succeeded but
> ibv_dofork_range unlikely might fail.

Correct.

> Current code behaves as done in other places in the library (e.g.
> ibv_dereg_mr), this unlikely case is ignored and user didn't get any
> indication despite the fact that this address range is in some undefine=
d
> state.

Probably not the best thing, but also at the same time, by the time
madvise fails this request, we are likely on a machine that's only two
steps from dying anyway.  I'm not entirely sure how much we care here.

> If makes sense we can change in rereg_mr from above behavior and return=

> an error.
>=20
> The question is which error we want to return, one option is just to
> return the ibv_dofork_range error code, application should dereg the MR=

> as described above in the man page.
>=20
> Alternatively, we can return a specific error code for that case lettin=
g
> the user know that the API has succeeded but there might be some issue
> with the do_fork. This special error code will be document in the man p=
age.

We only get here if we already have one error code to return (from the
driver's rereg_mr), and now we have a second error code.  Returning two
error codes is problematic.  So, the API could be changed to following:

Return Code:

	0 on success
	-1 on single failure, error is in errno
	-2 on multiple failure, first error is in errno, second failure
unreported, but always means that ibv_dofork_range on the original
memory range was not properly restored after the first failure

> Looking at errno.h not sure whether there is some error that match for
> that case, we also must be sure that this error code won't be returned
> from any driver/vendor as part of the rereg_mr flow.
>=20
> If makes sense we can define some new set of libibverbs error codes
> which are not part of errno range (e.g. enum ibv_error_code
> IBV_ERR_FORK_STATE_UNDEFINED =3D 0xff0000) and return/document it. This=

> set can be enlarged in the future for other similar cases.
>=20
> Which option do you prefer ? let's agree on, then will fix and resend.

I would probably leave it as is, or make the API as I suggested above.
It really is rare, but to be 100% correct we would need something like
the above API that doesn't put the error in the return so we have the
option of using the return to indicate number of errors.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--SADNTH0CRDEPc8X7CAFqCpbP3eJjJod7P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2Fv9AAoJELgmozMOVy/dfFgP/jctY8wB+tCP5OF9cMYw9cUq
9nA8hx+XpFmRxnZwoQguPj8Ta84qT4xNOnDy0/wqAIyEsK3yQorAxAuuMm+yC4Ai
0mVcjP1LaRhfi22OoWAiGeRDd49LLYxFRMeqp3ZUBV1dPnKMps2ZkXY/ix2X9q6p
QFiup/16BDaFMfK/xUZpVkoYv/8SPMcjrZVmUFZwJARMpcmxONbIGzNNRsKe6tSK
3MZBEmIDBnoouFvnFWWlhYVT1VJoFdO/OisghAs+J83ojhBLSfciCodi1P8Ajoze
2S5QBcd7yPgwLaKGF/vkq0XBVbTyO1sB06N9FDJ6NuT2BTXMDtJ/7BbhhHLSdWsB
t+iGold1zebNHpvMSAMEhwGlwomePSqmGV5CBIjkPsmS72FZaHCYV33jp2Q87JOD
jxeyurFsD2M0ccFoTP+KWqx1ztJdCyP7bxscG0Jq2clMzmiFIktuTDct7x/zrQQ5
3VnTlh9LYpN7xG6UhWJ2ZC003jIKC4DFe07IQuax51Ctb25luyquHXLYlYJ6lCAJ
IyinuBSuhHbq6M7TXj2sGFWC8G5JteDH46yGmuXR5xtOOHDjWNem1StNohKHgHUW
G1krHNucwmngf4LOwCD6g0Sb2oYDbuVtJkcTM1Re7l+8EoRgDQ+OXOb10zPqKbRx
Owek7oMcvUTMXJm3Hj4I
=KJSV
-----END PGP SIGNATURE-----

--SADNTH0CRDEPc8X7CAFqCpbP3eJjJod7P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
