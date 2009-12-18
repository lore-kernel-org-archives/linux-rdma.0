From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH 03/12] opensm: Remove unused port specification from
 torus-2QoS config file parsing.
Date: Fri, 18 Dec 2009 13:56:13 -0700
Message-ID: <1261169773.7690.262.camel@sale659.sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
 <1261169461-2516-4-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=-OS2pu/7J50vx40tYpikc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1261169461-2516-4-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-OS2pu/7J50vx40tYpikc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


The patch this email replies to changes the format of the torus-2QoS.conf
file.  The attached file works with the new format, and replaces the
example file sent in reply to the original torus-2QoS patch series.

-- Jim


--=-OS2pu/7J50vx40tYpikc
Content-Disposition: attachment;
 filename=torus-2QoS-5x5x5.conf
Content-Type: text/plain;
 charset=utf-8;
 name=torus-2QoS-5x5x5.conf
Content-Transfer-Encoding: 7bit

# We want the torus routing engine to attempt to find a
# 5x5x5 torus in the fabric:
torus 5 5 5

# We need to tell the routing engine what directions we
# want the torus coordinate directions to be, by specifing
# the endpoints (switch GUID only) of a link in each
# direction.  Here we specify positive coordinate directions:
xp_link 0x200000  0x200019   # S_0_0_0 -> S_1_0_0
yp_link 0x200000  0x200005   # S_0_0_0 -> S_0_1_0
zp_link 0x200000  0x200001   # S_0_0_0 -> S_0_0_1

# If one of the above switches were to fail, the routing
# engine would not have sufficient information to locate the
# torus in the fabric.  Specify a backup origin here:

next_origin
xp_link 0x20001f  0x200038   # S_1_1_1 -> S_2_1_1
yp_link 0x20001f  0x200024   # S_1_1_1 -> S_1_2_1
zp_link 0x20001f  0x200020   # S_1_1_1 -> S_1_1_2

# The torus routing engine uses the concept of a dateline,
# where a coordinate wraps from its maximum back to zero,
# in order to compute path SL values that provide routing
# that is free from credit loops.
#
# If it is forced by a failed switch to use the backup
# origin specification, that would cause the datelines
# to move, which would change many path SL values, which
# defeats one of the main benefits of this routing engine.
# So, describe the position of the original datelines
# relative to the backup origin as follows:
x_dateline -1
y_dateline -1
z_dateline -1

# You can specify as many backup origins as you like, but
# in practice, the torus routing engine is only guaranteed
# to be able to route around a single failed switch without
# introducing credit loops, so one backup origin is enough.

--=-OS2pu/7J50vx40tYpikc--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
