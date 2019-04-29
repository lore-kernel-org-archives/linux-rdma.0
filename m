From: Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 13:02:31 +0100
Message-ID: <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429111836.GA17830@osadl.at>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 29/04/2019 12:18, Nicholas Mc Guire wrote:
> On Mon, Apr 29, 2019 at 12:00:06PM +0100, Edward Cree wrote:
>> Again, a __force cast doesn't seem necessary here.  It looks like the
>>  code is just using the wrong types; if all of src, dst and uncongested
>>  were __le64 instead of uint64_t, and the last two lines replaced with
>>  rds_cong_map_updated(map, le64_to_cpu(uncongested)); then the semantics
>>  would be kept with neither sparse errors nor __force.
>>
>> __force is almost never necessary and mostly just masks other bugs or
>>  endianness confusion in the surrounding code.  Instead of adding a
>>  __force, either fix the code to be sparse-clean or leave the sparse
>>  warning in place so that future developers know there's something not
>>  right.
>>
> changing uncongested to __le64 is not an option here - it would only move
> the sparse warnings to those other locatoins where the ports that 
> became uncongested are being or'ed into uncongested.
That's why I say to change *src and *dst too.  Sparse won't mind the
 conversion from void * to __le64 * when they're assigned, and the only
 operations we do on them...
>                         uncongested |= ~(*src) & *dst;
>                         *dst++ = *src++;
... are some bitwise ops on the values (bitwise ops are legal in any
 endianness) and incrementation of the pointers (which cares only about
 the pointee size, not type).

-Ed
