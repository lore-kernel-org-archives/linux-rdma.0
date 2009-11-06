From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 19/25] mlx4: Randomizing mac addresses for slaves
Date: Fri, 6 Nov 2009 15:06:24 +1100
Message-ID: <20091106040624.GA6629@verge.net.au>
References: <4AF19E69.8070605@mellanox.co.il>
 <adar5seys3e.fsf@cisco.com>
 <15ddcffd0911041333l165ee274mfae3508a3db755e7@mail.gmail.com>
 <2ED289D4E09FBD4D92D911E869B97FDD0166CA59@mtlexch01.mtl.com>
 <adabpjhc6az.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <adabpjhc6az.fsf@roland-alpha.cisco.com>
Sender: netdev-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Liran Liss <liranl@mellanox.co.il>, Or Gerlitz <or.gerlitz@gmail.com>, Yevgeny Petrilin <yevgenyp@mellanox.co.il>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Tziporet Koren <tziporet@mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 05, 2009 at 07:58:12AM -0800, Roland Dreier wrote:
> 
>  > This approach seems to be common practice now (e.g., drivers/net/igb/igb_main.c:1332).
>  > In any case, the user can change the randomized mac.
> 
> igb uses the full output of random_ether_addr().  I'd be fine with
> that.  However setting the OUI means you only get 24 bits of randomness
> which makes a collision a lot more likely.

IIRC that was precisely why the OUI isn't used for the igb driver.

Perhaps some infrastructure (by which I mean a random_mac() function)
is warranted so at least this discussion can be concentrated around that
rather than repeating it for each driver that needs random mac addresses.


