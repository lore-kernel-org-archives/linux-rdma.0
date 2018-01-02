From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Tue, 2 Jan 2018 11:34:03 +0200
Message-ID: <CAJ3xEMixQ-Tw9gUYYPhNLvrEbntNTQBvLcVUe+x130hkEq15Bg@mail.gmail.com>
References: <20171224125741.25464-1-leon@kernel.org> <20171224125741.25464-3-leon@kernel.org>
 <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com> <b329f348-2462-2bf4-ee06-064e798c9b86@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b329f348-2462-2bf4-ee06-064e798c9b86-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 5:27 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/24/2017 4:00 PM, Or Gerlitz wrote:

>>> @@ -5531,6 +5533,7 @@ struct mlx5_ifc_init_hca_in_bits {
>>>         u8         op_mod[0x10];
>>>
>>>         u8         reserved_at_40[0x40];
>>> +       u8         sw_owner_id[4][0x20];
>>>  };

>> can we do here just a plane addition of bits? don't have the code
>> infront of me, but seems suspicious

> I don't understand what you are asking.  This is what the tool generated.

Dan, the tool is serving us and not the other way around, so

before your changes we had:

struct mlx5_ifc_init_hca_in_bits {
        u8         opcode[0x10];
        u8         reserved_at_10[0x10];

        u8         reserved_at_20[0x10];
        u8         op_mod[0x10];

        u8         reserved_at_40[0x40];
};

and now we have a struct which is 128b bigger
but is used for the same FW command

struct mlx5_ifc_init_hca_in_bits {
        u8         opcode[0x10];
        u8         reserved_at_10[0x10];

        u8         reserved_at_20[0x10];
        u8         op_mod[0x10];

        u8         reserved_at_40[0x40];

        u8         sw_owner_id[16][0x8];
};

my question is if/why this is legal. Maybe I am wrong, but
I don't think we can just go and change the size of the inbox
payload for a command. Maybe there's another (silent) reserved
space which is not present in the original form of the struct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
