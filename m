From: Marcel Apfelbaum <marcel@redhat.com>
Subject: Re: [PATCH] drivers/rxe: improve rxe loopback
Date: Thu, 27 Jul 2017 12:55:57 +0300
Message-ID: <778dcc67-30f2-aecc-3e53-7cf4d0afb74e@redhat.com>
References: <20170726145248.21677-1-marcel@redhat.com>
 <20170726195727.GB2339@yuvallap>
 <CAG9sBKNbC=TzgMpSuiGwiBJo_ZX0eSoQfni2YRUHg9J96yNkww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG9sBKNbC=TzgMpSuiGwiBJo_ZX0eSoQfni2YRUHg9J96yNkww@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On 27/07/2017 10:04, Moni Shoua wrote:
> On Wed, Jul 26, 2017 at 10:57 PM, Yuval Shaia <yuval.shaia@oracle.com> wrote:
>> On Wed, Jul 26, 2017 at 05:52:48PM +0300, Marcel Apfelbaum wrote:
>>> Currently a packet is marked for loopback only if the source and
>>> destination address match. This is not enough when multiple
>>> gids are present in rxe's gid table and the traffic is
>>> from one gid to another.
>>>
>>> Fix it by marking the packet for loopback if the destination
>>> address appears in rxe's gid table.
>>>
>>> Signed-off-by: Marcel Apfelbaum <marcel@redhat.com>
>>
> Have you considered using ip_route_output_key() for IPv4 or
> ip6_route_output() for IPv6 to decide if  this is a loopback?
> For reference you can check the flow starting at  rdma_resolve_ip()
> 

Hi Moni,

Yes, I had looked into it, but I haven't seen how I can find
out if the destination IP belongs to the same RXE.
The loopback flag will give us the "same host"
confirmation, but not the same rxe instance, right?

Any ideas would be welcomed.

Thanks,
Marcel
