From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] Avoid running out of local port in RDMA_CM
Date: Thu, 24 Nov 2016 10:03:08 +0200
Message-ID: <CAG9sBKN6uzTqxek_C5r4yWhqY94=FYUVuzRDLBPmEFUQ6QDHgg@mail.gmail.com>
References: <CAG9sBKMMuj5Qf7_jgL_EAwOAVAFZCp5Wf=NytqsHAezrys97pA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0B611D@ORSMSX109.amr.corp.intel.com>
 <CAG9sBKMfGWv7-wgoSNxVqMs7TktcJ3a4J0QnL+TmPSm1kaQ28g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0B6164@ORSMSX109.amr.corp.intel.com>
 <CAG9sBKO7YVjKgGMOMBUxrtz3iU5GtkqPFu6j52g=RqR=d_0HHA@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A82373AB0B8B08@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0B8B08-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 24, 2016 at 1:29 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> The documentation for struct inet_bind_bucket  says:
>> /* There are a few simple rules, which allow for local port reuse by
>>  * an application.  In essence:
>>  *
>>  *      1) Sockets bound to different interfaces may share a local
>> port.
>>  *         Failing that, goto test 2.
>>  *      2) If all sockets have sk->sk_reuse set, and none of them are
>> in
>>  *         TCP_LISTEN state, the port may be shared.
>>  *         Failing that, goto test 3.
>>  *      3) If all sockets are bound to a specific inet_sk(sk)-
>> >rcv_saddr local
>>  *         address, and none of them are the same, the port may be
>>  *         shared.
>>  *         Failing this, the port cannot be shared.
>> ..
>>
>> If I understand this correctly the suggestion in the RFC follows this
>> scheme so the request to mimic TCP/IP stack seems to be fulfilled.
>
> I don't see how the proposal fulfills the above requirements (3 may be th=
e key one here).  If I understand the proposal correctly, you're wanting to=
 re-use the same port number for all connections (once the port numbers run=
 out) without checking that the local or remote addresses differ.

Maybe the suggestion isn't clear enough but it refers to port numbers
that no application is listening on. I should have added it to the
conditions for reusing a port. The suggestion also skips step #1
(checking different interfaces).
So actually, I can rewrite the suggestion and say that a local port in
RDMA_CM may be shared if both conditions below are true
1. No one listens on the port
2. The reuse flag is set in all rdma_ids that bind to this port.

TCP doesn't check that remote addresses differ so I don't add it to
the suggestion as well
TCP checks that local addresses differ if step #2 fails (someone is
listening on the port) but RDMA_CM code already implements this logic
(via bind list)

The use of global port for reuse or just peek a random port and reuse
it if conditions above are fulfilled is an implementation detail. I
prefer the global port solution but I'm OK with the other.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
