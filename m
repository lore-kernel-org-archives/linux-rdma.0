From: Olga Kornievskaia <olga.kornievskaia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: insight into a WARNING from softROCE
Date: Thu, 4 Jan 2018 16:59:07 -0500
Message-ID: <CAN-5tyHNsusrU8Rrd6Rr9a=jsp3ROW5fiBOtsy3nF8HfBOmUgA@mail.gmail.com>
References: <CAN-5tyFENoK6f20zjeUEbXNQh-bZAaH-iBf4Q6G8uLjz0eHnqA@mail.gmail.com>
 <CAG9sBKM2qTSrB2sZnrLsUxAhL+ADursUTyPojd8HY5PF4Nf9Zg@mail.gmail.com>
 <581B7086-DBD2-4121-8A71-03E10757B4A1@gmail.com> <CAG9sBKOQ-gn8int2TSjnEo147jR2=Pnv7xKJqgs5iV3S7qFTEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKOQ-gn8int2TSjnEo147jR2=Pnv7xKJqgs5iV3S7qFTEQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 25, 2017 at 6:09 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Fri, Dec 22, 2017 at 5:43 PM, Olga Kornievskaia
> <olga.kornievskaia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hi Moni,
>>
>>> On Dec 21, 2017, at 3:19 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>> Hi Olga
>>> As far as I can tell the warning in
>>> drivers/infiniband/sw/rxe/rxe_comp.c:741 went through check_psn() ->
>>> COMPST_ERROR_RETRY -> COMPST_ERROR. In that case the wqe_status should
>>> have been IB_WC_RETRY_EXC_ERR and not IB_WC_SUCCESS.
>>
>> My conclusion was from trying to figure out why the warning was seen in =
var log messages which then followed with error that retry limit exceeded a=
nd connection manager dropping and re establishing the connection. Sounds l=
ike my conclusion wasnt correct.
>>
>> It seems like this warning is meant to signal that something went wrong =
in the code and this state of wqe status success yet being in error state i=
s unexpected.
>>
>> I thought the developers would be interested in investigating but maybe =
it=E2=80=99s not an interesting condition. Specially since it sounds like y=
our assessment is that packet loss causes the hiccup.
>>
>> I wish then there was a warning that notes packet loss and warns the use=
r. I understand the protocol assumes lossless communication so it shouldn=
=E2=80=99t be dealing w packet loss.
>>
>>> Can you please be more specific and explain how did you get to this con=
clusion?
>>
>> What other specifics can I provide? I added printks trying to trace the =
WARN message. Should I share a patch w printks w the output?
> I wonder how we get to this point when status is IB_WC_SUCCESS but
> through retry exceeded error. If you traced it maybe you can explain.

Sorry I was pulled off into doing testing over hardware RDMA and
haven't gotten back to softRoce. I will try get back it soon. I did
re-run this on the real machines (instead of VMs) and I saw the same
WARNING (on 4.15-rc4) kernel. In this case, softROCE was run over 10G
NICs using ibg drivers.

>>> BTW, what was the test you were running?
>>
>> I was running NFS testsuite (cthon). This was done on a laptop running 2=
VMs.
> I don't promise that we will run it immediately but it if you provide
> a HOWTO for this test I will appreciate it.

git clone git://git.linux-nfs.org/projects/steved/cthon04.git
cd cthon04
make
mount -o vers=3D4.1,rdma,port=3D20049 <serverip>:<servermountpoint> /mnt
(if instructions are needed to setup rdma nfs it would really depend
on which distro you are using. Redhat has howto to setup NFSoRDMA).
./runtest -a -f /mnt/data
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
