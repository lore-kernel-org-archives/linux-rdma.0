From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/mlx5: give back valid speed/width even without plugged
 in SFP module
Date: Sat, 28 Oct 2017 07:59:01 -0400
Message-ID: <a44f22b4-460c-d2c3-d9f9-c4769fb4293f@dev.mellanox.co.il>
References: <64ef31c8-cb1a-4579-ba12-11fbf6d1d5c0@default>
 <0af834ca-52ff-47da-a225-744aab4e59d6@dev.mellanox.co.il>
 <9be6d049-c3fc-6cf2-8d91-4449f4bcc896@oracle.com>
 <4dcf0ca6-77ff-bfd3-9f79-c114617f536f@dev.mellanox.co.il>
 <20171028124244.34dcc77d90637f5fc4a77017@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171028124244.34dcc77d90637f5fc4a77017@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Ghazale Hosseinabadi <ghazale.hosseinabadi@oracle.com>, linux-rdma@vger.kernel.org, matanb@mellanox.com, leonro@mellanox.com, parav@mellanox.com, linux-kernel@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On 10/28/2017 6:42 AM, Thomas Bogendoerfer wrote:
>> I must be missing something as to what is going on in this scenario.

I think I see what's going on now. The -EINVAL in kernel sysfs/rate_show
causes error to either open or read of file. I had checked that an empty
file is parsed correctly but didn't consider an error on open or read.

>> sysfs.c:rate_show is inconsistent as it paves over an invalid speed
>> setting that to SDR but does not pave over invalid width returning
>> -EINVAL but this comment is in another "direction".
> I thought about going in the other direction by making the speed/width unknown case
> somehow visible in rate_show(). When I checked all other drivers only mlx5 stand out
> so I decided to only change mlx5. But I make a change to let rate_show() print out, 
> that is currently has no rate for the port.

I wasn't proposing to make that visible in rate_show() but rather
pointing out the inconsistency in changing unknown speeds to SDR but
unknown widths are error. There were comments on not having to set
"random" numbers for speed/width. If so, shouldn't these be handled
consistently here ? Would setting -EINVAL when not one of recognized
speeds cause an issue (rather than setting to SDR) ?

IMO a more future proof implementation is not to have error for
ib_width_enum_to_int but have unknown widths default to 1x similar to
how unknown speeds default to SDR:

include/rdma/ib_verbs.h:
static inline int ib_width_enum_to_int(enum ib_port_width width)
{
        switch (width) {
        case IB_WIDTH_1X:  return  1;
        case IB_WIDTH_4X:  return  4;
        case IB_WIDTH_8X:  return  8;
        case IB_WIDTH_12X: return 12;
        default:          return 1;
        }
}

For example, 2x link widths have been added to IBA spec.

This is alternative approach to libibumad/ibstat patches for invalid
link width as it's not set when QSFP is not plugged into port.

-- Hal
