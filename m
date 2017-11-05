From: Alaa Hleihel <alaa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package list
 of SuSE Leap
Date: Sun, 5 Nov 2017 10:13:57 +0200
Message-ID: <76d45899-f1ec-bbd1-e0dd-799e1fa4a400@dev.mellanox.co.il>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
 <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
 <20171102174220.GD16127@mtr-leonro.local>
 <b2493da4-396e-5d24-ffa5-2fcccb9ee85c@suse.de>
 <20171102183257.GI16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102183257.GI16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 02/11/2017 20:32, Leon Romanovsky wrote:
> On Thu, Nov 02, 2017 at 07:04:36PM +0100, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 02/11/2017 à 18:42, Leon Romanovsky a écrit :
>>> On Thu, Nov 02, 2017 at 06:32:09PM +0100, Nicolas Morey-Chaisemartin wrote: >> Leon, Jason, is there any news on switching the upstream validation to build/validate for all distrib instead of just the "travis" one ? > > This is the ultimate goal of this series.
>> Sounds good. In that case, it might be worth adding tumbleweed to the distrib beeing built.
>> Most of the SUSE bleeding-edge user are using TW as it provides the latest kernel/packages.
> The preference is to have one latest distribution per distro, otherwise
> the CI will take a lot of time to complete. It makes sense to replace
> leap with tumblweed.

Hi Nicolas,

I've tried to build RPMs for tumbleweed, but it fails with the following error:
$ buildlib/cbuild pkg tumbleweed
error: Failed build dependencies:
        curl-mini is needed by rdma-core-16-0.x86_64

Seems like there is no such package available for Tumbleweed ..

########################################################################
$ buildlib/cbuild pkg tumbleweed --run-shell
builder-24bcec44f958:~/rpmbuild # cat /etc/issue
Welcome to openSUSE Tumbleweed 20171102 - Kernel \r (\l).

builder-24bcec44f958:~/rpmbuild # zypper search curl-mini
Loading repository data...
Reading installed packages...
No matching items found.

builder-24bcec44f958:~/rpmbuild # zypper search curl
Loading repository data...
Reading installed packages...

S | Name                | Summary                                                      | Type
--+---------------------+--------------------------------------------------------------+--------
  | curl                | A Tool for Transferring Data from URLs                       | package
  | curlftpfs           | Filesystem for mounting FTP hosts using FUSE and libcurl     | package
  | flickcurl           | Command-Line Tools for the Flickr Web Service                | package
  | flickcurl-doc       | Documentation for flickcurl, a Flickr Web Service C library  | package
  | gambas3-gb-net-curl | The advanced networking component for Gambas                 | package
  | ghc-curl            | Haskell binding to libcurl                                   | package
  | ghc-curl-devel      | Haskell curl library development files                       | package
  | libcurl-devel       | A Tool for Transferring Data from URLs                       | package
  | libcurl-devel-32bit | A Tool for Transferring Data from URLs                       | package
i | libcurl4            | Version 4 of cURL shared library                             | package
  | libcurl4-32bit      | Version 4 of cURL shared library                             | package
  | libflickcurl-devel  | Development files for flickurl, a Flickr Web Service library | package
  | libflickcurl0       | C Library API to the Flickr Web Service                      | package
  | libflickcurl0-32bit | C Library API to the Flickr Web Service                      | package
  | php7-curl           | libcurl integration for PHP                                  | package
  | python-pycurl-doc   | Documentation for python-curl                                | package
  | python2-pycurl      | PycURL -- cURL library module                                | package
  | python3-pycurl      | PycURL -- cURL library module                                | package
  | qemu-block-curl     | Universal CPU emulator -- cURL block support                 | package
  | syslog-ng-curl      | Curl (HTTP) destination support for syslog-ng                | package
  | tclcurl             | Tcl Binding to libcurl                                       | package
  | xmms2-plugin-curl   | Curl support for xmms2                                       | package
########################################################################


However, after removing the requirement for curl-mini, I was able to build RPMs successfully under Tumbleweed.
Can I submit a patch for removing these lines ?

--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec

-%if 0%{?suse_version} >= 1330
-BuildRequires:  curl-mini
-%endif
-


Regards,
Alaa


>>>>> After this series will be fixed and merged, we will have containerized SuSE/CentOS/Debian builds in travis, > and next step will be upload those artifacts to https://packagecloud.io/, so people won't need to create > distro packages for master branch. It will be there for them.
>> FYI, I've already setup something in OBS that does it for the SUSE packages:
>> https://build.opensuse.org/package/show/science:HPC:Head/rdma-core
>>
>> I've a Jenkins job that pulls github and automatically update this OBS repository.
>> They definitly should *NOT* be used for anything but testing.
>>
>>>>> In regards of schedule, there is already weekend in IL and Alaa will continue > to work on this series next week. After that, I'll setup and connect packagecloud > to our account.
>> Great !
>>
>> Nicolas
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
