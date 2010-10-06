From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Wed, 6 Oct 2010 11:57:44 -0700
Message-ID: <AANLkTimVvGGW6e=f-gL_Xz1vV4azHuST=6wy8Eba1G35@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A71DAA57-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry to revive a stale thread, but I wanted to post an update and see
about getting this rolling again.

I tried the suggestion of removing the call to ib_send_cm_mra().
Unfortunately, doing this wedges the stack 100% of the time.  Since
the original post, I've upgraded to CentOS-5.5 with OFED-1.5.1.  The
NULL pointer reference now occurs far less frequently but still with
some regularity.  I have full memory dumps from a crashed kernel, but
don't really know how to debug it.

-JE

On Wed, Jul 21, 2010 at 11:13 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> =A0[<ffffffff88407850>] :rdma_cm:rdma_init_qp_attr+0xed/0x13f
>> =A0[<ffffffff8841725e>] :rdma_ucm:ucma_init_qp_attr+0x97/0xe4
>> =A0[<ffffffff8008a461>] default_wake_function+0x0/0xe
>> =A0[<ffffffff8008a461>] default_wake_function+0x0/0xe
>> =A0[<ffffffff800d66d2>] shmem_file_write+0x23f/0x251
>> =A0[<ffffffff88416326>] :rdma_ucm:ucma_write+0x73/0x91
>> =A0[<ffffffff8001659e>] vfs_write+0xce/0x174
>> =A0[<ffffffff80016e6b>] sys_write+0x45/0x6e
>> =A0[<ffffffff8005d116>] system_call+0x7e/0x83
>
> Here's a guess at what may be happening:
>
> The rdma_cm receives a REQ, in cma_req_handler() we have:
>
> =A0 =A0 =A0 =A0ret =3D conn_id->id.event_handler(&conn_id->id, &event=
);
> =A0 =A0 =A0 =A0if (!ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Acquire mutex to prevent user execu=
ting rdma_destroy_id()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * while we're accessing the cm_id.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_lock(&lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cma_comp(conn_id, CMA_CONNECT) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!cma_is_ud_ps(conn_id->id.ps))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ib_send_cm_mra(cm_id, =
CMA_CM_MRA_SETTING, NULL, 0);
>
> Note that the call to ib_send_cm_mra() is after the event has been re=
ported to the user. =A0I'm guessing that the connection is getting esta=
blished before the call to ib_send_cm_mra() is invoked. =A0ib_send_cm_m=
ra() does this:
>
> =A0 =A0 =A0 =A0case IB_CM_ESTABLISHED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cm_state =3D cm_id->state;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lap_state =3D IB_CM_MRA_LAP_SENT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msg_response =3D CM_MSG_RESPONSE_OTHER=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0...
>
> =A0 =A0 =A0 =A0cm_id->state =3D cm_state;
> =A0 =A0 =A0 =A0cm_id->lap_state =3D lap_state;
> =A0 =A0 =A0 =A0cm_id_priv->service_timeout =3D service_timeout;
>
> If the cm_id state is established when ib_send_cm_mra() is called, th=
e lap_state is changed. =A0This would result in cm_init_qp_rts_attr() i=
ncorrectly falling into:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cm_id_priv->id.lap_state =3D=3D IB=
_CM_LAP_UNINIT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> ---> here
>
> where the alt_av.port would not be set.
>
> If this is what is happening, then removing the call to ib_send_cm_mr=
a() from cma_req_handler() should eliminate the crash. =A0The drawback =
is that connections may begin timing out under load, but it may be wort=
h trying. =A0I'll see if I can come up with a better fix.
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
