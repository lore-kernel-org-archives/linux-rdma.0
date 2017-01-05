From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: rdma-core package version schema
Date: Thu, 05 Jan 2017 20:01:07 +0100
Message-ID: <1483642867.5227.18.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I looked at the Debian packaging of rdma-core and stumbled over the
versioning. You change the version of the binary library packages
(libibcm1, libibumad3, etc.) from the Debian package version (currently
12-1) to their shared library versions. This change is uncommon and
confusing besides other issues. [1] It is common that the package
version differ from the library (soname) version. As potential Debian
sponsor I would reject this package version change.

The second problematic thing is that each library has its own major and
minor number, but use the package version as patch level. This
restricts the package version to one number which will increase fast.

>From my Debian maintainer perspective, I recommend following change:
Maintain two different versions, the package version and the library
versions.

The package version could follow the semantic versioning [2], the
version schema from the kernel [3], or by date [4]. Make that version
number be useful in itself. I suggest to start with version 2.0 (since
1.3.10 is the highest version that I found in one of its libraries when
they were maintained separately).

For the library version numbers, you could either maintain them
separately (increase only if you touch that library between two
releases) or maintain a common patch level (like you do now).

PS: I am thinking about offering becoming a co-maintainer for the rdma-
core Debian package.

[1] Andrey Rahmatullin wrote in https://bugs.debian.org/850145 :
"Please make sure you fully understand the consequences of using binary
package versions different from the source one."
[2] http://semver.org/
[3] major.minor.patch were major is increased when minor becomes too
big.
[4] year.${number of release of the year}.patch (e.g. 2017.1)

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:  http://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
