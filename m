From: Martin Kletzander <mkletzan@redhat.com>
Subject: Re: [PATCH] staging: rdma: Fix braces around if/else
Date: Sun, 4 Oct 2015 11:05:50 +0200
Message-ID: <20151004090550.GA4161@wheatley>
References: <1b3a2e933e163bf11a2163c76bedd074551c1b9a.1443901389.git.mkletzan@redhat.com>
 <5610CB98.1090907@mellanox.com> <20151004072009.GA8336@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8905355523168629953=="
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151004072009.GA8336@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Sean Hefty <sean.hefty@intel.com>
List-Id: linux-rdma@vger.kernel.org


--===============8905355523168629953==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Sun, Oct 04, 2015 at 08:20:09AM +0100, Greg Kroah-Hartman wrote:
>On Sun, Oct 04, 2015 at 09:47:52AM +0300, Or Gerlitz wrote:
>> On 10/3/2015 11:55 PM, Martin Kletzander wrote:
>> >Get rid of all ELSE_AFTER_BRACE type errors reported by checkpatch.pl.
>>
>> Hi Greg,
>>
>> Is there a way to signal people/tools that a certain driver parks in staging
>> on their way **out** of the kernel
>> and not the other way around? I guess you (nor Doug) don't want to spend
>> time on fixing such drivers, right?
>
>I'm not spending the time :)
>
>But no, there isn't a way to really show that that I know of, and it's
>fine, we end up getting a number of "cleanup" patches for a kernel
>release or two before the drivers get deleted.  It gets people involved
>in kernel development which is the key thing here, it's not like they
>are actually using these drivers...
>
>So it's fine, I take the patches, the people writing the patches are
>happy, and the code gets a bit nicer and feels better about itself
>before we kick it out the door.
>

I didn't mean to waste anyone's time on this.  I'm just trying to get
more familiar with the patch submission process into the kernel.  And
I'm doing this in my free time despite the address used.  I probably
should've noted that below to commit message.

Martin

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWEOvtAAoJEAgfwp8kF4bde64P/1608F/RvyZxw/+PNNYx+bgR
wXxycNHd30nHNM9BUUuuxdxvlt6NpV4OWxNXn/FvY2K9Q9QWIpPXMl2GV5p9eO1y
P0tjylynQ5AjmHLncZFhB9vD4f/rV8t7xGfK5BTBkUWDNUFjDpb06U1ritE4F/+n
D96gQaXfMYs8c7PndVxproX7UHASElqXZG7XJpeEz3x0GMCe7qRUAe6mgllrZTzb
Npe1Loq0orgL0rWopcWDGrb8uPTbQJtnUj56EBaikw+9uL1+FoC0qtizadND3ITg
G2Ftbey7BjIa0v03Wg4k2YHT7GNY6HyTTq5bTOlXdAhKiVUuSxpjlcUgwqzD/KDg
bNMdqCc+9T+RnBThViBoRGXTAzhbXwQ0NApo2B1QMc0GsrSJN5WM/fZThrDGI9A/
1XuGBy3Im+i7t2oZ/QB2DKLHMU8JOZoRNux0N0tOD8jbNbGPHB3Y6HX4Zya+ckv6
nFEJJMz2kCTrjrvJOydt7t+ihYNyvkq55WzMAZz+IGZOSJDCnxopoKaqDuZlrrBP
zVntEZ2W2b/2ZCzCdkX6isR/NjumFLDmz1E6hJUUHzsf1MLD/koP3QLlmC9HzeSI
xnsNi2Y/s7fTzY6YD8IStk+p2RYLq0KBH/wv+gRZ4RADBWD/6Tw0U6hRwcPAPeWP
fBhb7McfpEPQTC3zu+FX
=4oL2
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--

--===============8905355523168629953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--===============8905355523168629953==--
