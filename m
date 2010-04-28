From: Justin Clift <justin-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Subject: Initial patch for OFED 1.5.x to work on RHEL 6
Date: Wed, 28 Apr 2010 14:13:57 +1000
Message-ID: <4BD7B605.2070203@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Taking a look at the RHEL6 beta at the moment.  It was failing 
compilation of OFED 1.5.1 release on the main ofa kernel rpm, giving the 
same error reported by Jeremy Enos back in Aug 2009 on Fedora 10.

Thankfully the problem turned out to be a bug in the scripting in the 
rpm's spec file, easily fixed, which let's this now compile fine:

**********************************************************

--- ofa_kernel.spec_orig	2010-04-28 13:01:43.505217495 +1000
+++ ofa_kernel.spec	2010-04-28 13:52:44.386217393 +1000
@@ -188,6 +188,7 @@
  if [ -n "$modsyms" ]; then
  	for modsym in $modsyms
  	do
+		mkdir -p $RPM_BUILD_ROOT/%{_prefix}/src/%{_name}
  	        cat $modsym >> 
$RPM_BUILD_ROOT/%{_prefix}/src/%{_name}/Module.symvers
  	done
  else
@@ -800,9 +801,7 @@
  %files -n kernel-ib-devel
  %defattr(-,root,root,-)
  %dir %{_prefix}/src
-%{_prefix}/src/%{_name}-%{_version}
  %{_prefix}/src/%{_name}
-%{_prefix}/src/openib
  %endif

  # END Files

**********************************************************

The "mkdir -p" is the important part that needed adding, and should be 
safe to add on all the platforms.

Near the end however, it needed the removal of two directories not built 
on RHEL 6.  Not sure if they do get built on other platforms though. 
Vladimir Sokolovsky would probably know. :)

Hope that helps.

Regards and best wishes,

Justin Clift

-- 
Salasaga  -  Open Source eLearning IDE
               http://www.salasaga.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
