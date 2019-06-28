From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v4 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
Date: Fri, 28 Jun 2019 17:21:41 -0600
Message-ID: <10ad5a7d-b539-4847-c588-4c1a647e3c29@gmail.com>
References: <20190628095426.2819-1-dkirjanov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190628095426.2819-1-dkirjanov@suse.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On 6/28/19 3:54 AM, Denis Kirjanov wrote:
> Current code assumes that we print ethernet mac and
> that doesn't work in the IPoIB case with SRIOV-enabled hardware
> 
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state
> disable,
>     trust off, query_rss off
>     ...
> 
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
> 
> v1->v2: updated kernel headers to uapi commit
> v2->v3: fixed alignment
> v3->v4: aligned print statements as used through the source
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  ip/ipaddress.c | 40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 

Fixed the alignment issues and applied.
