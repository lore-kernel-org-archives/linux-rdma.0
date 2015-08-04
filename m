From: Amir Vadai <amirv.mellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Tue, 04 Aug 2015 17:17:24 +0300
Message-ID: <55C0C974.5080804@gmail.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com> <20150731073420.GB2485@infradead.org> <55BD2D57.8030107@redhat.com>
Reply-To: amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BD2D57.8030107-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 8/1/2015 11:34 PM, Doug Ledford wrote:
> On 07/31/2015 03:34 AM, Christoph Hellwig wrote:
>>> On Fri, Jul 31, 2015 at 02:05:06AM +0300, Or Gerlitz wrote:
>>>>> So... enough is enough, please put it in a kernel module
>>>>> residing in the IB core and use it in this driver, to begin
>>>>> with. The fact that ipath is going to go, makes the cope
>>>>> duplication "only" 2X vs the 3X, but it's still 2X
>>> 
>>> Agreed.  Any if anyone tries to submit software RoCE again
>>> it'll be another duplication.
> Or, I haven't looked at the soft-roce driver (ever).  Is it going
> to need this library as well?  If it is, then as you have rung the
> bell for getting this library written, I will expect Mellanox to
> work with Intel to make sure that this library is suitable for not
> just their hardware drivers but also the soft-roce driver you guys
> are working on.  I might even suggest that it's time to work up the
> soft-roce submission sooner rather than later in light of what I've
> done with the hfi1 driver.

Hi,

Soft RoCE driver is basically ready for submission, and should be
posted to the mailing list very soon (It is already in github [1] for
few month now).

We will gladly cooperate on a transport library. Maybe we should have
a shared session in LPC at Seattle. The relevant people from Mellanox
should be there.

[1] - kernel: https://github.com/SoftRoCE/rxe-dev
      User lib: https://github.com/SoftRoCE/librxe-dev

Amir
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVwMl0AAoJEAgXBixSko7zUgMQAJAJ9HilTLP4bBS1DtRk/KAk
+3y5CrYYhdDQErzqAngf56lH2tz3LVIW54sotZFRd7eBWq+9BjXcTQYwMUrntNAv
+Xo3uxUYpS0TN8VlpuMDdPGBm0HUW6PKW2smOJrknJ2CcZ5qSmZhJJKpF26hiRRm
y5livcyvcMoooeCS8T4ooAhVJkbaOTB+ksvXfI+tsfZoC9qs5Tl5PWi8b1YXgo0F
1udZGOoMz0G3ln3nd+zZzLOzEzfZofeugx39CHwprMey34lw5ed0w8167zRuVwYN
ShKDrOpUDYFvGmlJWOaro4hnG9jjqPT82rxLBpH3ZXCpV9mPC9Pu1uahxkt4wSIP
Cfslop4BKMLA83S3rUOVeencK5VWEFAghwxXuJosv3NayMWYP9xB+Cg9BXk3nnkn
rb2zokv8sXhSZyVKZSLXDezdYOsL33V06am3fQ2w0aCnfZ2wvNAugOA9IKRmKuHJ
6dUJQI6ybw8mW+/mlYzbLYG+0Gfw9oThrJOp6Urdc2bgrHj5SHGJY0C2Yz30O1QJ
CPwK81oDcWEofKKGT1NIw5JzZcNWW31D/f6d2CjbtJb9fnaOn7BFQheJSpSTGkzb
CJOWpWkqWHuxnNnh7IbQb/hAz7B/fSAf6JZnnYJRFShntsSMNFC89xMop4RYpI3z
JpA7hitZjWcFoviGlyw5
=otpU
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
