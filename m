From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: HA mode bonding for IB over SDP
Date: Wed, 6 Apr 2011 13:32:21 +0300
Message-ID: <BANLkTikSRxjYP+GThu7u5jLwGq+v_7JFAA@mail.gmail.com>
References: <loom.20110401T070836-761@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110401T070836-761-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhavin <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, nirm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If you want a reference code that works you can browse cmpost (get
from git clone git://git.openfabrics.org/~shefty/rdma-dev.git -
chechout branch test-apps).

There are several design issues that you need to resolve before you
start to implement.
Examples:
1. Where to add the code to
   - SDP: via direct calls to APM functions in CM
   - RDMA_CM: enhance interface
2. How to determine endpoints of alt path
3. What to do when migration occurs
4. exchange alt path info during connection establishment or after
connection establishment (LAP)

If you have specific questions then we'd be happy to share our
experience and try to answer.


If you want a reference code that works you can browse cmpost (get
from git clone git://git.openfabrics.org/~shefty/rdma-dev.git -
chechout branch test-apps).

There are several design issues that you need to resolve before you
start to implement.
Examples:
1. Where to add the code to
   - SDP: via direct calls to APM functions in CM
   - RDMA_CM: enhance interface
2. How to determine endpoints of alt path
3. What to do when migration occurs
4. exchange alt path info during connection establishment or after
connection establishment (LAP)

If you have specific questions then we'd be happy to share our
experience and try to answer.



On Fri, Apr 1, 2011 at 8:11 AM, Bhavin <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> Hi,
>
> I am a student pursuing masters. I have chosen to work on infiniband =
for my
> final year project. As part of my project I am trying to implement in=
finiband
> over SDP. I have also setup two systems for this purpose having Malla=
nox IB
> cards. I found that OFED doesn=92t have support for HA mode failover =
for IB over
> SDP when searching for limitations of this configuration. So I have d=
ecided to
> work on this issue.
>
> Right now I am going through the OFED source code to understand how d=
ifferent
> functionalities are implemented. I also found there is something call=
ed
> APM(Automatic Path Migration) is present in OFED.
>
> Is it possible to use APM for failover with IB over SDP? If yes, plea=
se guide me
> on how can I use APM for IB over SDP.
>
> Please Help.
>
> Thanks
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
