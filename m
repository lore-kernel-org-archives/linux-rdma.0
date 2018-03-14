From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] infiniband: qplib_fp: fix pointer cast
Date: Wed, 14 Mar 2018 13:31:36 -0700
Message-ID: <CA+55aFxEsTA7DTBYdLz8sbniq2NRO-X+Nt1vmYxckfWAP0BQZQ@mail.gmail.com>
References: <20180220205638.1959033-1-arnd@arndb.de> <20180228211514.GC13394@ziepe.ca>
 <CAK8P3a2dsQ7QAb64DCp9Fc2xXjEyHNjBFdRc=y6FanQKsXhADg@mail.gmail.com>
 <20180306234539.GB1037@ziepe.ca> <CAK8P3a0mHEm8m8=CfV5Qmw0EcVCc31OetdFXHQ0KEvWk6K40Gw@mail.gmail.com>
 <CAK8P3a2cqjQzhaPwk9rE6=s4QQVFk8vAoYQfqSrh1nOi-KpZew@mail.gmail.com>
 <CAK8P3a2SS4RBwjrd2XCnpA8W_bmHtjdjWdX1RTnkou0OQ5ROdA@mail.gmail.com>
 <1521057831.18703.101.camel@redhat.com> <CAK8P3a1=h7cF8kRUWpFG88-OSFL8_7SgUkaX4TUEhG6ypPODkg@mail.gmail.com>
 <1521059294.18703.106.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521059294.18703.106.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eddie Wai <eddie.wai@broadcom.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 14, 2018 at 1:28 PM, Doug Ledford <dledford@redhat.com> wrote:
>
> Arnd sent in a two patch series and it got put into our for-next branch.
>  But, the two patches are the *only* two remaining issues for the arm
> builds on the kernelci system.  They would like to get this into for-rc
> so that the build failures stop.  Are you OK with me just cherry-picking
> them from for-next to for-rc so I can send them to you?  They'll show as
> duplicates in the next merge window, but should drop silently.

Go ahead, assuming there are no other planned changes around them that
would cause potential pointless merge problems..

           Linus
