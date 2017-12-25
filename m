From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: insight into a WARNING from softROCE
Date: Mon, 25 Dec 2017 13:09:10 +0200
Message-ID: <CAG9sBKOQ-gn8int2TSjnEo147jR2=Pnv7xKJqgs5iV3S7qFTEQ@mail.gmail.com>
References: <CAN-5tyFENoK6f20zjeUEbXNQh-bZAaH-iBf4Q6G8uLjz0eHnqA@mail.gmail.com>
 <CAG9sBKM2qTSrB2sZnrLsUxAhL+ADursUTyPojd8HY5PF4Nf9Zg@mail.gmail.com> <581B7086-DBD2-4121-8A71-03E10757B4A1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <581B7086-DBD2-4121-8A71-03E10757B4A1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <olga.kornievskaia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 22, 2017 at 5:43 PM, Olga Kornievskaia
<olga.kornievskaia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Moni,
>
>> On Dec 21, 2017, at 3:19 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Hi Olga
>> As far as I can tell the warning in
>> drivers/infiniband/sw/rxe/rxe_comp.c:741 went through check_psn() ->
>> COMPST_ERROR_RETRY -> COMPST_ERROR. In that case the wqe_status should
>> have been IB_WC_RETRY_EXC_ERR and not IB_WC_SUCCESS.
>
> My conclusion was from trying to figure out why the warning was seen in v=
ar log messages which then followed with error that retry limit exceeded an=
d connection manager dropping and re establishing the connection. Sounds li=
ke my conclusion wasnt correct.
>
> It seems like this warning is meant to signal that something went wrong i=
n the code and this state of wqe status success yet being in error state is=
 unexpected.
>
> I thought the developers would be interested in investigating but maybe i=
t=E2=80=99s not an interesting condition. Specially since it sounds like yo=
ur assessment is that packet loss causes the hiccup.
>
> I wish then there was a warning that notes packet loss and warns the user=
. I understand the protocol assumes lossless communication so it shouldn=E2=
=80=99t be dealing w packet loss.
>
>> Can you please be more specific and explain how did you get to this conc=
lusion?
>
> What other specifics can I provide? I added printks trying to trace the W=
ARN message. Should I share a patch w printks w the output?
I wonder how we get to this point when status is IB_WC_SUCCESS but
through retry exceeded error. If you traced it maybe you can explain.
>
>> BTW, what was the test you were running?
>
> I was running NFS testsuite (cthon). This was done on a laptop running 2V=
Ms.
I don't promise that we will run it immediately but it if you provide
a HOWTO for this test I will appreciate it.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
