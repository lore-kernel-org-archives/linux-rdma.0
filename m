From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Enhance device capabilities flags debug
 printouts
Date: Sun, 25 Jan 2015 12:36:30 +0200
Message-ID: <20150125103629.GB6463@yuval-lab>
References: <1417996112-19060-1-git-send-email-yuval.shaia@oracle.com>
 <54881BFF.2030008@mellanox.com>
 <20141215092153.GF2806@yuval-lab>
 <CAJ3xEMght7jLakWzDOHvqTT_gNSqJJHAjLu_F6gD0j+=Narqmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMght7jLakWzDOHvqTT_gNSqJJHAjLu_F6gD0j+=Narqmg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> >-                       mlx4_dbg(dev, "    %s\n", fname[i]);
> >> >+               if (fname[i])
> >> >+                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
> >> >+                                '*' : ' ', fname[i]);
> >> >  }
> >>
> >> I think that the strings should be displayed only if both driver and
> >> FW supports them. You could add a QUERY_DEV_CAP_SUPPORTED_FLAGS
> >> which ors all the supported flags in device.h and check if (flags &
> >> QUERY_DEV_CAP_SUPPORTED_FLAGS) & (1LL << i)).
But that would add an extra place to maintain when new feature will be added to driver, isn't it?
At present, when new feature is added to driver enum and string array needs to be updated.
With this new approach, string array is full, need only to add new enum and to update QUERY_DEV_CAP_SUPPORTED_FLAGS.
Again, two places in the code to change.
Up to you folks, which one you like better?
I like the new approach, it is less error prone.
> >>
> >> >
> >> >  static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> >> >@@ -144,8 +172,9 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> >> >         int i;
> >> >
> >> >         for (i =; i < ARRAY_SIZE(fname); ++i)
> >> >-               if (fname[i] && (flags & (1LL << i)))
> >> >-                       mlx4_dbg(dev, "    %s\n", fname[i]);
> >> >+               if (fname[i])
> >> >+                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
> >> >+                                '*' : ' ', fname[i]);
> >> >  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
