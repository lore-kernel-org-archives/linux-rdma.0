From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rsockets and fork
Date: Sun, 2 Dec 2012 14:20:14 +0200
Message-ID: <50BB477E.6000907@mellanox.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com> <502A9039.4090505@us.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com> <1344968289.2101.36.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com> <1345239625.1128.20.camel@oc1677441337.ibm.com> <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com> <CAL1RGDW+QSXnfa5yvEsb7XqXMVbVVU6sz7BEKRPmc0tSYi8m9Q@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237346A8ADD4@ORSMSX101.amr.corp.intel.com> <CAJZOPZJWzKZ3fjUsbBVA8-Dv+YTajJBStP2VzBw
 =VrfXHSi=xw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237346ADAC17@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346ADAC17-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eyal Salomon <esalomon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/11/2012 18:27, Hefty, Sean wrote:
> Fork support in rsockets is available now, and netperf should work.

Sean,

Trying the latest  librdamcm git (+ the patch I sent to have it build 
OK), we weren't able to run netperf

here's the server output
> starting netserver with host '192.168.20.126' port '12865' and family 
> AF_UNSPEC
> accept_connections: enter
> set_fdset: enter list 0x22ea840 fd_set 0x7fff7134e040
> setting 3 in fdset
> accept_connection: enter
> spawn_child: enter
> close_listens: enter
> set_fdset: enter list 0x22ea840 fd_set 0x7fff7134e040
> setting 3 in fdset

and this is the client output

> resolve_host called with host '192.168.20.126' port '(null)' family 
> AF_UNSPEC
> getaddrinfo returned the following for host '192.168.20.126' port 
> '(null)'  family AF_UNSPEC
>         cannonical name: '192.168.20.126'
>         flags: 22 family: AF_INET: socktype: SOCK_STREAM protocol 
> IPPROTO_TCP addrlen 16
>         sa_family: AF_INET sadata: 0 0 192 168 20 126 0 0 0 0 0 0 0 0 0 0
> scan_omni_args called with the following argument vector
> netperf -v 2 -d -H 192.168.20.126
> Program name: netperf
> Local send alignment: 8
> Local recv alignment: 8
> Remote send alignment: 8
> Remote recv alignment: 8
> Report local CPU 0
> Report remote CPU 0
> Verbosity: 2
> Debug: 1
> Port: 12865
> Test name: TCP_STREAM
> Test bytes: 0 Test time: 10 Test trans: 0
> Host name: 192.168.20.126
>
> installing catcher for all signals
> Could not install signal catcher for sig 32, errno 22
> Could not install signal catcher for sig 33, errno 22
> Could not install signal catcher for sig 65, errno 22
> remotehost is 192.168.20.126 and port 12865
> resolve_host called with host '192.168.20.126' port '12865' family AF_INET
> getaddrinfo returned the following for host '192.168.20.126' port 
> '12865'  family AF_INET
>         cannonical name: '192.168.20.126'
>         flags: 22 family: AF_INET: socktype: SOCK_STREAM protocol 
> IPPROTO_TCP addrlen 16
>         sa_family: AF_INET sadata: 50 65 192 168 20 126 0 0 0 0 0 0 0 
> 0 0 0
> resolve_host called with host '0.0.0.0' port '0' family AF_UNSPEC
> getaddrinfo returned the following for host '0.0.0.0' port '0' family 
> AF_UNSPEC
>         cannonical name: '0.0.0.0'
>         flags: 22 family: AF_INET: socktype: SOCK_STREAM protocol 
> IPPROTO_TCP addrlen 16
>         sa_family: AF_INET sadata: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> establish_control called with host '192.168.20.126' port '12865' 
> remfam AF_INET
>                 local '0.0.0.0' port '0' locfam AF_UNSPEC
> bound control socket to 0.0.0.0 and 0
> successful connection to remote netserver at 192.168.20.126 and 12865
> recv_response: received a 0 byte response
> recv_response: partial response received: 0 bytes


We used netperf version is 2.5.0

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
