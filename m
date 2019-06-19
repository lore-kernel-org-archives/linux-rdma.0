From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 v2 2/2] uapi: update if_link.h
Date: Wed, 19 Jun 2019 13:31:00 -0600
Message-ID: <f17e6784-c021-ce7a-c64b-1868e6d8b609@gmail.com>
References: <20190619141414.4242-1-dkirjanov@suse.com>
 <20190619141414.4242-2-dkirjanov@suse.com>
 <20190619104652.4c71c33b@hermes.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190619104652.4c71c33b@hermes.lan>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>, Denis Kirjanov <kda@linux-powerpc.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
List-Id: linux-rdma@vger.kernel.org

On 6/19/19 11:47 AM, Stephen Hemminger wrote:
> On Wed, 19 Jun 2019 16:14:14 +0200
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
> 
>> update if_link.h to commit 75345f888f700c4ab2448287e35d48c760b202e6
>> ("ipoib: show VF broadcast address")
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> 
> This is only on net-next so the patches should target iproute2-next.
> 
> David can update from that.
> 

Make uapi changes as a separate patch; don't worry about syncing the
entire file. That patch is my hint to resync the kernel headers to top
of tree before applying the rest of the set.
