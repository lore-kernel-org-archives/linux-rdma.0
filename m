From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 08:36:27 -0700
Message-ID: <4156c03f-4977-17eb-db64-6df775b6e592@sandisk.com>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 05/30/16 03:09, Max Gurtovoy wrote:
> ib_device_cap_flags 64-bit expansion caused a possible caps overlapping
> (depending on machine endianness) and made consumers read wrong device
> capabilities. For example IB_DEVICE_SG_GAPS_REG was falsely read by the
> iser driver causing it to use a non-existing capability. Fix this by
> casting ib_device_cap_flags enumerations to ULL.
>
  > [ ... ]
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> [ ... ]
>  enum ib_device_cap_flags {
  >       [ ... ]
>  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>       [ ... ]
>  };

How can this patch make a difference? The presence of any constant in an 
enum that does not fit in a 32-bit integer makes an enum 64 bits wide. 
In other words, all the changes from "1" into "1ULL" in this patch do 
not have any effect. From the C standard: "Each enumerated type shall be 
compatible with char, a signed integer type, or an unsigned integer 
type. The choice of type is implementation-defined but shall be capable 
of representing the values of all the members of the enumeration. [...] 
An implementation may delay the choice of which integer type until all 
enumeration constants have been seen."

Bart.
