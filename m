From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 2 Sep 2016 17:10:45 -0700
Message-ID: <ef8214f8-d44d-2289-d1ed-a0998e9e05c0@sandisk.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
 <20160902233231.GA26309@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902233231.GA26309-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/02/2016 04:32 PM, Jason Gunthorpe wrote:
> On Thu, Sep 01, 2016 at 01:36:16PM -0500, Steve Wise wrote:
>>> Seems reasonable and on theme.
>>>
>>> What do you want to do with the emulate_udev directory? It doesn't
>>> even look like it is built..
>>>
>>> So we have nominations for
>>>
>>> srptools http://git.openfabrics.org/?p=~bvanassche/srptools.git/.git.
>>> perftest git://git.openfabrics.org/~grockah/perftest.git master
>>> iwpm ?? (Steve Wise: do you have a cannonical link for this, Google isn't
>>>          helping me?)
>>
>> git://git.openfabrics.org/~tnikolova/libiwpm
>>
>> Tatyana, please correct me if I'm wrong.
> 
> Bart, Steve, Sagi:
> 
> Done. I left out perftest as Doug requested.
> 
> https://github.com/jgunthorpe/rdma-plumbing
> 
> We will need to get a systemd service file for srp_daemon, and iwpm
> is missing man pages, but those are pre-existing problems.
> 
> Can you please let me know if this works for you?
> 
> iwpm in particular didn't even build (auto* drift) on a modern distro
> so I'm a bit skeptical...
> 
> Be aware, by default 'make install' will not install the boot files
> for iwpm or srp_daemon in any useful place (as per GNU
> convention).
> 
> I recommend trying the sample rpm spec file, which does the right
> thing.

Hello Jason,

Can you have a look at the patch below? I needed it to make the spec
file usable on my development system.

Thanks,

Bart.
 

[PATCH] rdma-plumbing.spec: Port to SuSE platforms

Additionally, fix a syntax error in the non-ninja section.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 rdma-plumbing.spec | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/rdma-plumbing.spec b/rdma-plumbing.spec
index 050df0c..acb24bc 100644
--- a/rdma-plumbing.spec
+++ b/rdma-plumbing.spec
@@ -16,17 +16,24 @@ BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
 
-%if 0%{?fedora} >= 23
 # Since we recommend developers use Ninja, so should packagers, for consistency.
+%if %{expand:%%(rpm -q kernel-default >/dev/null 2>&1; echo $((1-$?)))}
+# openSuSE or SLES
+BuildRequires: ninja
+%define CMAKE_FLAG -GNinja
+%define MAKE_CMD ninja -v
+%else
+%if 0%{?fedora} >= 23
 # Ninja was introduced in FC23 and has not yet made it to an EL.
 BuildRequires: ninja-build
 %define CMAKE_FLAG -GNinja
 %define MAKE_CMD ninja-build -v
 %else
 BuildRequires: make
-%define CMAKE_FLAG
+%define CMAKE_FLAG %{nil}
 %define MAKE_CMD make
 %endif
+%endif
 
 %description
 Temporary packaging
-- 
2.9.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
